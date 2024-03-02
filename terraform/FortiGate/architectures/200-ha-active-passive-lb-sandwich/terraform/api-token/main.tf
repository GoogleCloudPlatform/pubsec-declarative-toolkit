module "fgt_ha" {
  source        = "git::github.com/fortinet/terraform-google-fgt-ha-ap-lb?ref=v1.0.0"

  region        = "us-central1"
  subnets       = [ "external", "internal", "hasync", "mgmt" ]

  api_accprofile        = "prof_admin"
  api_acl               = ["10.0.0.0/24"]
  api_token_secret_name = "fgt-api-secret"
}
