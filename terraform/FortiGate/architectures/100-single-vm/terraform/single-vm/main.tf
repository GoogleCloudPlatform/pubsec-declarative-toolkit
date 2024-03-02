terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    cloudinit = {
      source = "cloudinit"
    }
  }
}

#
# Pull default values
#
data "google_client_config" "default" {
  lifecycle {
    postcondition {
      condition     = can(coalesce(var.zone, self.zone))
      error_message = "Define GCE zone either in variables or in provider configuraton"
    }
  }
}
data "google_compute_default_service_account" "default" {}

#
# Apply defaults if not overriden in variables
#
locals {
  service_account = coalesce(var.service_account, data.google_compute_default_service_account.default.email)
  zone            = coalesce(var.zone, data.google_client_config.default.zone)
  region          = join("-", slice(split("-", local.zone), 0, 2))

  #sanitize labels
  labels = { for k, v in var.labels : k => replace(lower(v), " ", "_") }
}

# Auto-set NIC type to GVNIC if ARM image was selected
locals {
  nic_type = var.image.arch == "arm" ? "GVNIC" : var.nic_type
}

#
# Find image either based on version+arch+lic ...
#
module "fgtimage" {
  count = var.image.version == "" ? 0 : 1

  source = "github.com/40net-cloud/fortinet-gcp-solutions.git//FortiGate/modules-tf/fgt-get-image"
  ver    = var.image.version
  arch   = var.image.arch
  lic    = "${var.license_file}${var.flex_token}" != "" ? "byol" : var.image.lic
}
# ... or based on family/name
data "google_compute_image" "by_family_name" {
  count = var.image.version == "" ? 1 : 0

  project = var.image.project
  family  = var.image.name == "" ? var.image.family : null
  name    = var.image.name != "" ? var.image.name : null

  lifecycle {
    postcondition {
      condition     = !(("${var.license_file}${var.flex_token}" != "") && strcontains(self.name, "ondemand"))
      error_message = "You provided a FortiGate BYOL (or Flex) license, but you're attempting to deploy a PAYG image. This would result in a double license fee. \nUpdate module's 'image' parameter to fix this error.\n\nCurrent var.image value: \n  {%{for k, v in var.image}%{if tostring(v) != ""}\n    ${k}=${v}%{endif}%{endfor}\n  }"
    }
  }
}
# ... and pick one
locals {
  fgt_image = var.image.version == "" ? data.google_compute_image.by_family_name[0] : module.fgtimage[0].image
}

#
# Reserve External IP addresses
#
resource "google_compute_address" "pub" {
  for_each = toset(var.public_nics)

  name         = "${var.instance_name}-eip-${each.value}"
  address_type = "EXTERNAL"
  region       = local.region
  labels       = local.labels
}

#
# Reserve private addresses
#
resource "google_compute_address" "prv" {
  # use count instead of for_each, because the order is important
  count = length(var.subnets)

  name         = "${var.instance_name}-port${count.index + 1}"
  address_type = "INTERNAL"
  region       = local.region
  subnetwork   = var.subnets[count.index]
}

# 
# Pull more data about connected subnets
# This data is needed to configure routing on FortiGates
#
# NOTE: for the sake of performance we're only pulling connected subnets, not all subnets in connected VPC
# 
data "google_compute_subnetwork" "connected" {
  count = length(var.subnets)

  name   = var.subnets[count.index]
  region = local.region
}

locals {
  connected_subnets = { for indx, subnet in data.google_compute_subnetwork.connected : subnet.ip_cidr_range => { "gw" : subnet.gateway_address, "dev" : "port${indx + 1}", "name" : subnet.name } }
}


#
# Prepare bootstrap data
# - part 1 is optional FortiFlex license token
# - part 2 is bootstrap configuration script built from fgt_config.tftpl template
#
data "cloudinit_config" "fgt" {
  gzip          = false
  base64_encode = false

  dynamic "part" {
    for_each = var.flex_token == "" ? [] : [1]
    content {
      filename     = "license"
      content_type = "text/plain; charset=\"us-ascii\""
      content      = <<-EOF
        LICENSE-TOKEN: ${var.flex_token}
        EOF
    }
  }

  part {
    filename     = "config"
    content_type = "text/plain; charset=\"us-ascii\""
    content = templatefile("${path.module}/fgt_config.tftpl", {
      prv_ips    = google_compute_address.prv[*].address
      fgt_config = var.fgt_config
      hostname   = var.instance_name
      subnets    = local.connected_subnets
      default_gw = data.google_compute_subnetwork.connected[0].gateway_address
    })
  }
}

#
# Create logdisk
# 
resource "google_compute_disk" "logdisk" {
  name   = "${var.instance_name}-logdisk"
  size   = var.logdisk_size
  type   = "pd-ssd"
  zone   = local.zone
  labels = local.labels
}

#
# Create FortiGate VM instance
#
resource "google_compute_instance" "fgt" {
  name           = var.instance_name
  zone           = local.zone
  machine_type   = var.machine_type
  can_ip_forward = true
  labels         = local.labels
  tags           = var.fgt_tags

  boot_disk {
    initialize_params {
      image                 = local.fgt_image.self_link
      labels                = local.labels
      resource_manager_tags = {}
    }
  }

  dynamic "network_interface" {
    for_each = var.subnets

    content {
      subnetwork = network_interface.value
      nic_type   = local.nic_type
      network_ip = google_compute_address.prv[network_interface.key].address
      dynamic "access_config" {
        for_each = contains(var.public_nics, "port${network_interface.key + 1}") ? [1] : []
        content {
          nat_ip = google_compute_address.pub["port${network_interface.key + 1}"].address
        }
      }
    }
  }

  service_account {
    email  = local.service_account
    scopes = ["cloud-platform"]
  }

  metadata = {
    user-data          = data.cloudinit_config.fgt.rendered
    license            = alltrue([var.license_file != "", try(fileexists(var.license_file), false)]) ? file(var.license_file) : null
    serial-port-enable = var.serial_port_enable
  }
}

#
# Allow network access to FortiGate
#
resource "google_compute_firewall" "allowall" {
  #    for_each = {for indx,nic in google_compute_instance.fgt.network_interface : "port${indx+1}"=>nic.network }
  for_each = { for indx, subnet in data.google_compute_subnetwork.connected : "port${indx + 1}" => subnet.network }

  name    = "${var.instance_name}-allowall-${each.key}"
  network = each.value
  allow {
    protocol = "all"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.fgt_tags
}