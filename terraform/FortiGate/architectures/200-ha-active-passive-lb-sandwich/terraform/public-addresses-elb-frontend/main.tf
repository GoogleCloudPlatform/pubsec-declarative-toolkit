module "fgt_ha" {
  source        = "git::github.com/fortinet/terraform-google-fgt-ha-ap-lb?ref=v1.0.0"

  region        = "us-central1"
  subnets       = [ "external", "internal", "hasync", "mgmt" ]

  frontends = [
    "service1", # this will create a new address
    "service2", # this will create a new address
    "35.1.2.3"  # this will attach existing address (if found in your project and region, and if not used)
  ]
}
