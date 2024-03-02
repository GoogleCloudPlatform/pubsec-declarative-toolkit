module "fgt_ha" {
  source        = "git::github.com/fortinet/terraform-google-fgt-ha-ap-lb?ref=v1.0.0"

  region        = "us-central1"
  subnets       = [ "external", "internal", "hasync", "mgmt" ]

  flexvm_tokens = ["B1C38EDAEA0D4E568D2F", "9E8FF67B64924C3B82E1"]
  image_family  = "fortigate-70-byol"
}
