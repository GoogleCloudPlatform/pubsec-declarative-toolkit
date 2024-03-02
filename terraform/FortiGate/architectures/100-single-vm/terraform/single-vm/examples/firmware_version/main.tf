module "fgt" {
    source = "../.."

    subnets = [
        "external",
        "internal"
    ]
    zone = "us-central1-c"

# Select precise version and licensing
    image = {
        version = "7.2.6"
        lic = "byol"
    }
}

output "mgmt_ip" {
    value = module.fgt.ext_ips["port1"]
}

output "initial_password" {
    value = module.fgt.instance_id
}