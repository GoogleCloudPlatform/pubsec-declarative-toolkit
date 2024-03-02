terraform {
	required_providers {
	  google = {
		source = "hashicorp/google"
	  }
	}
}

locals {
	arch_post = substr(var.ver, 0, 2)=="7.2" && split(".", var.ver)[2] > 5 ? (var.arch=="arm" ? "arm64-" : "x64-" ) : ""
	arch_pre  = substr(var.ver, 0, 2)=="7.2" && split(".", var.ver)[2] > 5 ? "" : (var.arch=="arm" ? "arm64-" : "" )
	lic       = lower(var.lic)=="payg" ? "ondemand" : ""
	ver       = replace(var.ver, ".", "")
}


data "google_compute_image" "all" {
	project     = "fortigcp-project-001"
	filter      = "name eq fortinet-fgt${local.lic}-${local.arch_pre}${local.ver}-\\d{8}-\\d{3}-${local.arch_post}.*"
	most_recent = true
}


output "image" {
	value = data.google_compute_image.all
}

output "self_link" {
	value = data.google_compute_image.all.self_link
}

