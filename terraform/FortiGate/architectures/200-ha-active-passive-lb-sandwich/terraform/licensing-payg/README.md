# FortiGate licensing: PAYG

PAYG licensing is linked to the machine type used to run FortiGate VMs. License fee is calculated per hour of instance running and added to the Google Cloud invoice. To stop charges it is enough to stop the instances. It is the most flexible type of licensing available for FortiGates in public cloud.

Other licensing options for FortiGate supported by this module are:
- [BYOL](../licensing-byol)
- [FortiFlex](../licensing-flex)

## Configuration

PAYG licensing requires using special PAYG boot images published by Fortinet. All images with names containing "ondemand" or family name including "payg" published in fortigcp-project-001 project are PAYG images. To deploy a cluster with PAYG licensing set a proper value for `image_name` or `family_name` variables. By default the module deploys newest firmware in PAYG licensing.

See [docs/images.md](../../docs/images.md) for more information on obtaining images.

## Example

See [main.tf](main.tf) file for example code.
