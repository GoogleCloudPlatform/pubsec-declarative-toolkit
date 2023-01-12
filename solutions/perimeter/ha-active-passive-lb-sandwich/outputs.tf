# Output

output "FortiGate-HA-Active-MGMT-IP" {
  value = google_compute_instance_from_template.active_fgt_instance.network_interface.3.access_config.0.nat_ip
}

output "FortiGate-HA-Passive-MGMT-IP" {
  value = google_compute_instance_from_template.passive_fgt_instance.network_interface.3.access_config.0.nat_ip
}

output "FortiGate-Username" {
  value = "admin"
}

output "FortiGate-Password" {
  value = var.password
}
