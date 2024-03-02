resource "google_compute_image" "fgt_724_gvnic" {
  name         = "fgt-724-byol-gvnic"
  source_image = "projects/fortigcp-project-001/global/images/fortinet-fgt-724-20230310-001-w-license"

  guest_os_features {
    type = "GVNIC"
  }
}

module "fgt_ha" {
  source        = "git::github.com/fortinet/terraform-google-fgt-ha-ap-lb?ref=v1.0.0"

  region        = "us-central1"
  subnets       = [ "external", "internal", "hasync", "mgmt" ]

  image_name    = google_compute_image.fgt_724_gvnic.name
  image_project = google_compute_image.fgt_724_gvnic.project
  nic_type      = "GVNIC"
}
