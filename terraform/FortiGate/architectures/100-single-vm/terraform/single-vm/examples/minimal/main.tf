module "fgt" {
    source = "../.."
    subnets = [
        "external",
        "internal"
    ]
    zone = "us-central1-c"
}