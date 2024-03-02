output "fgt_public_addresses" {
    value = module.fgt.ext_ips
}

output "fgt_default_password" {
    value = module.fgt.instance_id
}