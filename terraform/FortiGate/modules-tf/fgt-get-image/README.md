# FortiGate Get Image in GCP - terraform module

This module helps you find the correct image based on the following search criteria:

- firmware version (var.ver - eg. "7.4.1", no default)
- licensing (var.lic - defaults to payg, allowed values: "payg", "byol")
- architecture (var.arch - defaults to x64, allowed values: "arm", "x64")

If multiple images are matching, the result will point to the latest one.

### Outputs

- self_link - URI of the image
- image - object with all image attributes

### Note

This module does not support searching by family. See [other examples](https://github.com/40net-cloud/fortinet-gcp-solutions/blob/master/FortiGate/docs/images.md#using-image-family-with-terraform) on how to use image family with terraform.