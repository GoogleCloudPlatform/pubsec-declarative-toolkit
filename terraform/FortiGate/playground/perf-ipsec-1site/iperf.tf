resource "google_compute_address" "iperfs" {
    name = "${var.prefix}-addr-iperfs"
    address_type = "INTERNAL"
    address = cidrhost(local.cidrs["int"], 100)
    subnetwork = google_compute_subnetwork.dut["int"].self_link
    region = var.region_dut
}

resource "google_compute_instance" "iperfs" {
    name = "${var.prefix}-iperfs"
    machine_type = "n2-standard-16"
    zone = "${var.region_dut}-b"

    boot_disk {
        initialize_params {
        image = "ubuntu-os-cloud/ubuntu-2004-lts"
        }
    }

    metadata_startup_script = <<EOF
    apt update 
    apt install iperf3 iperf nginx -y
    iperf3 -sD
    dd if=/dev/random of=/var/www/html/64k bs=1k count=64
    dd if=/dev/random of=/var/www/html/1M bs=1k count=1024
    sysctl -w net.ipv4.tcp_rmem="4096 87380 67108864"
    sysctl -w net.ipv4.tcp_wmem="4096 87380 67108864"
    EOF

    network_interface {
        network       = google_compute_network.dut["int"].self_link
        subnetwork    = google_compute_subnetwork.dut["int"].name
        network_ip =  google_compute_address.iperfs.address
        nic_type = "GVNIC"
        access_config {}
    }
    allow_stopping_for_update = true
    scheduling {
      provisioning_model = "SPOT"
      preemptible = true
      automatic_restart = false
    }
}

/** LEFT iperf client **/

resource "google_compute_instance" "dc_cli" {
    name = "${var.prefix}-iperf-cli"
    machine_type = "n2-standard-16"
    zone = "${google_compute_subnetwork.dc.region}-b"

    boot_disk {
        initialize_params {
        image = "ubuntu-os-cloud/ubuntu-2204-lts"
        }
    }

    metadata_startup_script = <<EOF
    apt update 
    apt install iperf3 iperf apache2-utils wrk -y
    sysctl -w net.ipv4.tcp_rmem="4096 87380 67108864"
    sysctl -w net.ipv4.tcp_wmem="4096 87380 67108864"
    EOF

    network_interface {
        network       = google_compute_network.dc.self_link
        subnetwork    = google_compute_subnetwork.dc.name
        nic_type = "GVNIC"
        access_config {}
    }
    allow_stopping_for_update = true
    scheduling {
      provisioning_model = "SPOT"
      preemptible = true
      automatic_restart = false
    }
}