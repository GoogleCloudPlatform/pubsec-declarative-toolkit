terraform {
  required_providers {
    google = {
      version = ">= 5.16.0"
      source = "hashicorp/google"
    }
  }
}

locals {
  network_names = [
    "ext",
    "int",
    "hamgmt"
  ]

  cidrs = {
    ext = "172.20.0.0/24"
    int = "172.20.1.0/24"
    hamgmt = "172.20.2.0/24"
  }

  tunnel_indx_set = toset([for i in range(var.tunnel_count) : tostring(i)])

  regions_short = {
    "dut": replace( replace( replace( replace( replace(replace(replace(replace(replace(replace(var.region_dut, "south", "s"), "east", "e"), "central", "c"), "north", "n"), "west", "w"), "europe-", "eu"), "australia-", "au" ), "northamerica-", "na"), "southamerica-", "sa"), "us-", "us"),
    "cli": replace( replace( replace( replace( replace(replace(replace(replace(replace(replace(var.region_cli, "south", "s"), "east", "e"), "central", "c"), "north", "n"), "west", "w"), "europe-", "eu"), "australia-", "au" ), "northamerica-", "na"), "southamerica-", "sa"), "us-", "us")    
  }

  cpumasks = [
    "0x1",
    "0x2",
    "0x4",
    "0x8",
    "0x10",
    "0x20",
    "0x40",
    "0x80",
    "0x100",
    "0x200",
    "0x400",
    "0x800",
    "0x1000",
    "0x2000",
    "0x4000",
    "0x8000",
  ]
  cpu_count = tonumber( split("-", var.machine_type)[2])
  queue_per_nic = var.opt_queues ? floor((local.cpu_count - 1)/2) : floor(local.cpu_count/3)
}


resource "random_string" "psksecret" {
  length = 20
  special = true
}

data "google_compute_default_service_account" "default" {}

module "fgt_image" {
  source = "./fgt-get-img"
  ver = var.firmware
  lic = try( var.flex_serials[0], "" ) == "" ? "payg" : "byol"
}

resource "google_compute_image" "gvnic" {
  count = var.nic_type == "GVNIC" ? 1 : 0
  name = "${var.prefix}-${module.fgt_image.image.name}-gvnic"
  source_image = module.fgt_image.self_link
  guest_os_features {
    type = "GVNIC"
  }
  guest_os_features {
    type = "UEFI_COMPATIBLE"
  }
}

locals {
  fgt_image_uri = var.nic_type == "VIRTIO_NET" ? module.fgt_image.self_link : try(google_compute_image.gvnic[0].self_link, "")
}

data "google_compute_machine_types" "dut" {
  zone = "${var.region_dut}-b"
  filter = "name=\"${var.machine_type}\""

  lifecycle {
    postcondition {
      condition = length(self.machine_types)>0
      error_message = "Machine type ${var.machine_type} is not available in zone ${var.region_dut}-b"
    }
  }
}

module "flex" {
  count = try(var.flex_serials[1], "") != "" ? 1 : 0
  source = "./flex"
  serials = var.flex_serials
}

resource "local_file" "test_script" {
  filename = "${path.module}/tests_run.sh"
  content = templatefile("${path.module}/tests.tftpl", {
    "clihost": google_compute_instance.dc_cli.name
    "clizone": google_compute_instance.dc_cli.zone
    "iperfs": google_compute_instance.iperfs.network_interface[0].access_config[0].nat_ip
  })
}