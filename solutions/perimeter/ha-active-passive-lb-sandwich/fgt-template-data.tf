# Configuration for FGT Instance using data
data "template_file" "setup-active-fgt-instance" {
  template = file("${path.module}/fgt-active-template")
  vars = {
    fgt_password             = var.password
    external_gateway         = var.external_gateway //  HA External Gateway
    internal_gateway         = var.internal_gateway //  HA Internal Gateway
    hamgmt_gateway           = var.mgmt_gateway     //  HA Management Gateway
    hb_netmask               = var.mgmt_mask        // Management netmask
    active_port1_ip          = var.active_port1_ip
    active_port2_ip          = var.active_port2_ip
    active_port3_ip          = var.active_port3_ip
    active_port4_ip          = var.active_port4_ip
    mask                     = var.mask
    passive_hb_ip            = var.passive_port3_ip // Passive Sync (HeartBeat) IP
    subnet_cidr_port1        = var.subnet_cidrs[0]
    subnet_cidr_port2        = var.subnet_cidrs[1]
    subnet_cidr_port3        = var.subnet_cidrs[2]
    subnet_cidr_port4        = var.subnet_cidrs[3]
    internal_loadbalancer_ip = google_compute_address.internal_address.address
    elb_ip1                  = module.static-ip-elb1.static_ip
    elb_ip2                  = module.static-ip-elb2.static_ip
  }
}

data "template_file" "setup-passive-fgt-instance" {
  template = file("${path.module}/fgt-passive-template")
  vars = {
    fgt_password             = var.password
    external_gateway         = var.external_gateway //  HA External Gateway
    internal_gateway         = var.internal_gateway //  HA Internal Gateway
    hamgmt_gateway           = var.mgmt_gateway     //  HA Management Gateway
    hb_netmask               = var.mgmt_mask        // Management netmask
    passive_port1_ip         = var.passive_port1_ip
    passive_port2_ip         = var.passive_port2_ip
    passive_port3_ip         = var.passive_port3_ip
    passive_port4_ip         = var.passive_port4_ip
    mask                     = var.mask
    subnet_cidr_port1        = var.subnet_cidrs[0]
    subnet_cidr_port2        = var.subnet_cidrs[1]
    subnet_cidr_port3        = var.subnet_cidrs[2]
    subnet_cidr_port4        = var.subnet_cidrs[3]
    active_hb_ip             = var.active_port3_ip // Active Sync (HeartBeat) IP
    internal_loadbalancer_ip = google_compute_address.internal_address.address
    elb_ip1                  = module.static-ip-elb1.static_ip
    elb_ip2                  = module.static-ip-elb2.static_ip
  }
}
