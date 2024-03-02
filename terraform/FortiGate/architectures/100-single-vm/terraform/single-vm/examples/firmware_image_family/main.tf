module "fgt" {
    source = "../.."

    subnets = [
        "external",
        "internal"
    ]
    zone = "us-central1-c"
    
# automatically select the latest PAYG image from 7.4 branch
    image = {
        family = "fortigate-74-payg"
    }
}

output "mgmt_ip" {
    value = module.fgt.ext_ips["port1"]
}

output "initial_password" {
    value = module.fgt.instance_id
}