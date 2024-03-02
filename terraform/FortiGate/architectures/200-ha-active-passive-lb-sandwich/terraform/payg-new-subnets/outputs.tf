output primary_fgt_mgmt_ip {
  value = module.fgt_ha.fgt_mgmt_eips[0]
}

output default_password {
  value = module.fgt_ha.fgt_password
}
