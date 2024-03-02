module "sample_networks" {
  source = "./sample-networks"

  networks = ["external","internal"]
  prefix = var.prefix
}

################################################################################

data "google_compute_image" "fgt_image" {
  project = "fortigcp-project-001"
  family  = "fortigate-64-byol"
}

resource "google_compute_instance" "fgt-vm" {
  name         = "${var.prefix}-fgt"
  machine_type = "e2-standard-2"
  can_ip_forward = true
  tags = ["fgt"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.fgt_image.self_link
    }
  }

  network_interface {
    network = module.sample_networks.vpcs[0]
    subnetwork = module.sample_networks.subnets[0]
    access_config {
    }
  }

  network_interface {
    network = module.sample_networks.vpcs[1]
    subnetwork = module.sample_networks.subnets[1]
  }
}

output "fgt-vm-eip" {
  value = google_compute_instance.fgt-vm.network_interface[0].access_config[0].nat_ip
}

output "default_password" {
  value = google_compute_instance.fgt-vm.instance_id
}
