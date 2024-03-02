module "fgt" {
    source = "../.."
    subnets = [
        "external",
        "internal"
    ]
    zone = "us-central1-c"
    labels = {
        "serial": "aaa"
    }
    image = {
        family = "fortigate-74-byol"
    }
    flex_token = "ABCDEFGH12345"
}