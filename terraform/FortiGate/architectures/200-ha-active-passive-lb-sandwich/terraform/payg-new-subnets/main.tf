locals {
  network_names = [
    "ext",
    "int",
    "hasync",
    "mgmt"
  ]

  cidrs = {
    ext = "172.20.0.0/24"
    int = "172.20.1.0/24"
    hasync = "172.20.2.0/24"
    mgmt = "172.20.3.0/24"
  }
}

#prepare the networks
resource google_compute_network "demo" {
  for_each      = toset(local.network_names)

  name          = "fgt-example-vpc-${each.value}"
  auto_create_subnetworks = false
}

resource google_compute_subnetwork "demo" {
  for_each      = toset(local.network_names)

  name          = "fgt-example-sb-${each.value}-${var.region_short}"
  region        = var.region
  network       = google_compute_network.demo[ each.value ].self_link
  ip_cidr_range = local.cidrs[ each.value ]
}

# deploy the FortiGates
module "fgt_ha" {
  source        = "git::github.com/fortinet/terraform-google-fgt-ha-ap-lb?ref=v1.0.0"

  prefix        = "fgt-example-payg"
  region        = var.region
  image_family  = "fortigate-72-payg"
  labels        = {
    owner : "johndoe"
    env   : "test"
  }
  frontends     = ["app1"]
  subnets       = [ for key in local.network_names: google_compute_subnetwork.demo[ key ].name ]

  depends_on    = [
    google_compute_subnetwork.demo
  ]
}
