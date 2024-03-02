resource "google_compute_network" "vpcs" {
  count                   = length(var.networks)
  name                    = "${var.prefix}-${var.networks[count.index]}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  count         = length(var.networks)
  name          = "${var.prefix}-${var.networks[count.index]}-sb"
  network       = google_compute_network.vpcs[count.index].self_link
  ip_cidr_range = "${var.ip_cidr_2oct}.${count.index}.0/24"
}

output "vpcs" {
  value = google_compute_network.vpcs[*].self_link
}

output "subnets" {
  value = google_compute_subnetwork.subnets[*].self_link
}
