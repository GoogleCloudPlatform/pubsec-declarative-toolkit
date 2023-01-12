provider "google" {
  version     = "3.49.0"
  credentials = file(var.credentials_file_path)
  project     = var.project
  region      = var.region
}

provider "google-beta" {
  version     = "3.49.0"
  credentials = file(var.credentials_file_path)
  project     = var.project
  region      = var.region
}

################
# RANDOM STRING
################
module "random" {
  source = "../../modules/random-generator"
}

######
# VPC
######
module "vpc" {
  source = "../../modules/vpc"
  # Pass Variables
  name = var.name
  vpcs = var.vpcs
  # Values fetched from the Modules
  random_string = module.random.random_string
}

#########
# SUBNET
#########
module "subnet" {
  source = "../../modules/subnet"

  # Pass Variables
  name         = var.name
  region       = var.region
  subnets      = var.subnets
  subnet_cidrs = var.subnet_cidrs
  private_ip_google_access = null
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = module.vpc.vpc_networks
}

###########
# FIREWALL
###########
module "firewall" {
  source = "../../modules/firewall"

  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = module.vpc.vpc_networks
}

###############
# CLOUD ROUTER
###############
module "cloud_router" {
  source = "../../modules/cloud_router"

  # Pass Variables
  name   = var.name
  region = var.region
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpc_network   = module.vpc.vpc_networks[0]
}

############
# CLOUD NAT
############
module "cloud_nat" {
  source = "../../modules/cloud_nat"

  # Pass Variables
  name   = var.name
  region = var.region
  # Values fetched from the Modules
  random_string = module.random.random_string
  cloud_router  = module.cloud_router.name
}

####################
# INSTANCE TEMPLATE
####################
resource "google_compute_instance_template" "active" {
  name        = "${var.name}-active-fgt-template-${module.random.random_string}"
  description = "Fortigate Active Instance Template"

  instance_description = "FortiGate Active Instance Template"
  machine_type         = var.machine
  can_ip_forward       = true
  tags                 = var.tags

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  # Create a new boot disk from an image
  disk {
    source_image = var.image
    auto_delete  = true
    boot         = true
  }
  # Logging Disk
  disk {
    auto_delete  = true
    boot         = false
    disk_size_gb = 30
  }
  # Public Network
  network_interface {
    network    = module.vpc.vpc_networks[0]
    subnetwork = module.subnet.subnets[0]
    # access_config {}
  }

  # Private Network
  network_interface {
    network    = module.vpc.vpc_networks[1]
    subnetwork = module.subnet.subnets[1]
  }

  # HA Sync Network
  network_interface {
    network    = module.vpc.vpc_networks[2]
    subnetwork = module.subnet.subnets[2]
  }

  # Mgmt Network
  network_interface {
    network    = module.vpc.vpc_networks[3]
    subnetwork = module.subnet.subnets[3]
    access_config {
    }
  }

  # Metadata to bootstrap FGT
  metadata = {
    user-data = data.template_file.setup-active-fgt-instance.rendered
    license   = var.license_file != null ? file(var.license_file) : null
}

  # Email will be the service account
  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_template" "passive" {
  name        = "${var.name}-passive-fgt-template-${module.random.random_string}"
  description = "Fortigate Passive Instance Template"

  instance_description = "FortiGate Passive Instance Template"
  machine_type         = var.machine
  can_ip_forward       = true
  tags                 = ["ha-instance"]

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  # Create a new boot disk from an image
  disk {
    source_image = var.image
    auto_delete  = true
    boot         = true
  }
  # Logging Disk
  disk {
    auto_delete  = true
    boot         = false
    disk_size_gb = 30
  }
  # Public Network
  network_interface {
    network    = module.vpc.vpc_networks[0]
    subnetwork = module.subnet.subnets[0]
    # access_config {}
  }

  # Private Network
  network_interface {
    network    = module.vpc.vpc_networks[1]
    subnetwork = module.subnet.subnets[1]
  }

  # HA Sync Network
  network_interface {
    network    = module.vpc.vpc_networks[2]
    subnetwork = module.subnet.subnets[2]
  }

  # Mgmt Network
  network_interface {
    network    = module.vpc.vpc_networks[3]
    subnetwork = module.subnet.subnets[3]
    access_config {
    }
  }

  # Metadata to bootstrap FGT
  metadata = {
    user-data = data.template_file.setup-passive-fgt-instance.rendered
    license   = var.license_file_2 != null ? file(var.license_file_2) : null
  }

  # Email will be the service account
  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}

###############
# Data Sources
###############
data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
  status  = "UP"
}

resource "google_compute_instance_from_template" "active_fgt_instance" {
  name                     = "${var.name}-fgt-0-${module.random.random_string}"
  zone                     = element(data.google_compute_zones.available.names, 0)
  source_instance_template = google_compute_instance_template.active.self_link

  network_interface {
    network_ip = var.active_port1_ip
    network    = module.vpc.vpc_networks[0]
    subnetwork = module.subnet.subnets[0]
  }
  network_interface {
    network_ip = var.active_port2_ip
    network    = module.vpc.vpc_networks[1]
    subnetwork = module.subnet.subnets[1]
  }
  network_interface {
    network_ip = var.active_port3_ip
    network    = module.vpc.vpc_networks[2]
    subnetwork = module.subnet.subnets[2]
  }
  network_interface {
    network_ip = var.active_port4_ip
    network    = module.vpc.vpc_networks[3]
    subnetwork = module.subnet.subnets[3]
    access_config {}
  }
}

resource "google_compute_instance_from_template" "passive_fgt_instance" {
  name                     = "${var.name}-fgt-1-${module.random.random_string}"
  zone                     = element(data.google_compute_zones.available.names, 1)
  source_instance_template = google_compute_instance_template.passive.self_link

  network_interface {
    network_ip = var.passive_port1_ip
    network    = module.vpc.vpc_networks[0]
    subnetwork = module.subnet.subnets[0]
  }
  network_interface {
    network_ip = var.passive_port2_ip
    network    = module.vpc.vpc_networks[1]
    subnetwork = module.subnet.subnets[1]
  }
  network_interface {
    network_ip = var.passive_port3_ip
    network    = module.vpc.vpc_networks[2]
    subnetwork = module.subnet.subnets[2]
  }
  network_interface {
    network_ip = var.passive_port4_ip
    network    = module.vpc.vpc_networks[3]
    subnetwork = module.subnet.subnets[3]
    access_config {}
  }

  depends_on = [google_compute_instance_from_template.active_fgt_instance]
}

###########################
# UnManaged Instance Group
###########################
resource "google_compute_instance_group" "umig_active" {
  name    = "${var.name}-unmig-0-${module.random.random_string}"
  project = var.project
  zone    = element(data.google_compute_zones.available.names, 0)
  instances = matchkeys(
    google_compute_instance_from_template.active_fgt_instance.*.self_link,
    google_compute_instance_from_template.active_fgt_instance.*.zone,
    [data.google_compute_zones.available.names[0]],
  )
}

resource "google_compute_instance_group" "umig_passive" {
  name    = "${var.name}-unmig-1-${module.random.random_string}"
  project = var.project
  zone    = element(data.google_compute_zones.available.names, 1)
  instances = matchkeys(
    google_compute_instance_from_template.passive_fgt_instance.*.self_link,
    google_compute_instance_from_template.passive_fgt_instance.*.zone,
    [data.google_compute_zones.available.names[1]],
  )
}

#########################
# Internal Load Balancer
#########################
resource "google_compute_address" "internal_address" {
  name         = "${var.name}-ilb-address-${module.random.random_string}"
  subnetwork   = module.subnet.subnets[1]
  address_type = "INTERNAL"
  address      = cidrhost(var.subnet_cidrs[1], 5)
  region       = var.region
}

resource "google_compute_forwarding_rule" "internal_load_balancer" {
  name       = "${var.name}-ilb-${module.random.random_string}"
  region     = var.region
  ip_address = google_compute_address.internal_address.address

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.internal_load_balancer_backend.self_link
  all_ports             = true
  network               = module.vpc.vpc_networks[1]
  subnetwork            = module.subnet.subnets[1]
}

resource "google_compute_region_backend_service" "internal_load_balancer_backend" {
  name    = "${var.name}-ilb-backend-${module.random.random_string}"
  region  = var.region
  network = module.vpc.vpc_networks[1]

  backend {
    group = google_compute_instance_group.umig_active.self_link
  }

  backend {
    group = google_compute_instance_group.umig_passive.self_link
  }

  health_checks = [
    google_compute_health_check.int_lb_health_check.id
  ]
}

# Health Check
resource "google_compute_health_check" "int_lb_health_check" {
  name = "${var.name}-healthcheck-ilb-${module.random.random_string}"
  http_health_check {
    port = var.int_port
  }
}

#########################
# External Load Balancer
#########################
module "static-ip-elb1" {
  source = "../../modules/static-ip"

  # Pass Variables
  name = "${var.name}-static-ip-elb1"
  # Values fetched from the Modules
  random_string = module.random.random_string
  region = var.region
}

module "static-ip-elb2" {
  source = "../../modules/static-ip"

  # Pass Variables
  name = "${var.name}-static-ip-elb2"
  # Values fetched from the Modules
  random_string = module.random.random_string
  region = var.region
}

resource "google_compute_forwarding_rule" "elb-tcp1" {
  name       = "${var.name}-elb-tcp1-rule-${module.random.random_string}"
  region     = var.region
  ip_address = module.static-ip-elb1.static_ip
  port_range = "1-65535"

  target = google_compute_target_pool.default.self_link
}

resource "google_compute_forwarding_rule" "elb-tcp2" {
  name       = "${var.name}-elb-tcp2-rule-${module.random.random_string}"
  region     = var.region
  ip_address = module.static-ip-elb2.static_ip
  port_range = "1-65535"
  target     = google_compute_target_pool.default.self_link
}

resource "google_compute_forwarding_rule" "elb_udp1" {
  name        = "${var.name}-elb-udp1-rule-${module.random.random_string}"
  region      = var.region
  ip_address  = module.static-ip-elb1.static_ip
  ip_protocol = "UDP"
  port_range  = "1-65535"
  target      = google_compute_target_pool.default.self_link
}

resource "google_compute_forwarding_rule" "elb_udp2" {
  name        = "${var.name}-elb-udp2-rule-${module.random.random_string}"
  region      = var.region
  ip_address  = module.static-ip-elb2.static_ip
  ip_protocol = "UDP"
  port_range  = "1-65535"
  target      = google_compute_target_pool.default.self_link
}

# Health Check
resource "google_compute_http_health_check" "ext_lb_health_check" {
  name                = "${var.name}-elbhealth-${module.random.random_string}"
  check_interval_sec  = var.elb_check_interval_sec
  timeout_sec         = var.elb_timeout_sec
  healthy_threshold   = var.elb_healthy_threshold
  unhealthy_threshold = var.elb_unhealthy_threshold
  port                = var.elb_port
}

# Target Pool
resource "google_compute_target_pool" "default" {
  name = "${var.name}-elb-pool-${module.random.random_string}"

  instances = [google_compute_instance_from_template.active_fgt_instance.self_link, google_compute_instance_from_template.passive_fgt_instance.self_link]

  health_checks = [
    google_compute_http_health_check.ext_lb_health_check.name
  ]
}

###########
# Routes
###########
resource "google_compute_route" "route_direct" {
  name             = "${var.name}-route-direct-${module.random.random_string}"
  dest_range       = var.dest_range
  network          = module.vpc.vpc_networks[0]
  tags             = var.tags
  priority         = 10
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_route" "ilb_route" {
  name         = "${var.name}-ilb-route-${module.random.random_string}"
  dest_range   = var.dest_range
  network      = module.vpc.vpc_networks[1]
  next_hop_ilb = google_compute_forwarding_rule.internal_load_balancer.self_link
  priority     = var.priority
}

