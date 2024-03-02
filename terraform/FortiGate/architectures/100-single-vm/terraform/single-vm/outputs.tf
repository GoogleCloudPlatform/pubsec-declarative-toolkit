output "ext_ips" {
  value = { for eip in google_compute_address.pub : trimprefix(eip.name, "${var.instance_name}-eip-") => eip.address }
}

output "prv_ips" {
  value = { for ip in google_compute_address.prv : trimprefix(ip.name, "${var.instance_name}-") => ip.address }
}

output "instance_id" {
  value = google_compute_instance.fgt.instance_id
}

output "self_link" {
  value = google_compute_instance.fgt.self_link
}

output "fgt_vm" {
  value     = google_compute_instance.fgt
  sensitive = true
}