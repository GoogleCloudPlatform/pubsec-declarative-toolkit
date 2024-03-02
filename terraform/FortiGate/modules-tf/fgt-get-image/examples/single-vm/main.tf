module "fgtimage" {
    source = "../.."
    ver    = "7.4.1"
}

data "google_compute_default_service_account" "default" {
}

resource "google_compute_instance" "fgt" {
    name           = "fortigate-vm"
    zone           = "us-central1-b"
    machine_type   = "e2-standard-2"
    can_ip_forward = true

    boot_disk {
      initialize_params {
        image      = module.fgtimage.self_link
      }
    }

    network_interface {
      subnetwork   = "external"
      access_config {}
    }

    network_interface {
      subnetwork   = "internal"
    }

    service_account {
      email        = data.google_compute_default_service_account.default.email
      scopes       = ["cloud-platform"]
    }
}