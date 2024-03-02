# Single FortiGate VM
## How to deploy using Terraform

### Prerequisites
Before you deploy a FortiGate instance, you need to create
- 2 VPC Networks (external and internal)
- with 1 subnet in each

Note: subnets must be in the same region where you plan to deploy your FortiGate instance.

You also must know the following values:
1. URL external subnet
1. URL internal subnet
1. URL of image you're going to deploy (see [this article](images.md) for more details)
1. zone where you want to create your FortiGate VM

### Deployment steps

Terraform is a declarative language describing your infrastructure as a readable code. You will have to do the following:
- create a text file (eg. `main.tf`)
- edit this file to describe what you want to deploy
- run terraform to apply changes described in the file to your GCP project

See [howto-tf.md](../../howto-tf.md) for introduction on how to use Terraform with GCP.

### `main.tf` code

Terraform `.tf` files use a special language (HCL) to describe resources to be deployed. Each resource consists of the `resource` keyword followed by the resource type and identifier (unique name used within tf file). Each resource will also take a set of arguments defining resource properties. A basic code for a VM instance deploying into "us-central1-b" zone would look like below:

```
resource "google_compute_instance" "fgt-vm" {
   name           = "my-fortigate"
   zone           = "us-central1-b"
   machine_type   = "e2-standard-2"
   can_ip_forward = true
}
```

To make it a FortiGate you have to provide it with a proper boot image. Fortinet publishes images for multiple versions of firmware - read [this article](images.md) to find out how to find one. You can also upload your own image. Your resource code for firmware 7.0.5 could now look like this:

```
resource "google_compute_instance" "fgt-vm" {
   name           = "my-fortigate"
   zone           = "us-central1-b"
   machine_type   = "e2-standard-2"
   can_ip_forward = true

   boot_disk {
     initialize_params {
       image      = "https://www.googleapis.com/compute/v1/projects/fortigcp-project-001/global/images/fortinet-fgt-705-20220211-001-w-license"
     }
   }
}
```

Your firewall needs to be connected to some networks. GCP VM instances support a maximum of 8 NICs for VMs with at least 8 vCPUs, but Fortinet recommends using only 2 NICs for forwarding traffic: external and internal (see [Peered Security Hub](../architectures/300-peered-security-hub) architecture for information on connecting more networks). You will need additional network interfaces if deploying an HA cluster. You create network interfaces by adding `network_interface` blocks to your `google_compute_instance` resource. Each of them needs at least a `subnetwork` name to be provided and external one can have an external IP connected by using an `access_config` sub-block.

Your `fgt-vm` resource should look now like this:

```
resource "google_compute_instance" "fgt-vm" {
   name           = "my-fortigate"
   zone           = "us-central1-b"
   machine_type   = "e2-standard-2"
   can_ip_forward = true

   boot_disk {
     initialize_params {
       image      = "https://www.googleapis.com/compute/v1/projects/fortigcp-project-001/global/images/fortinet-fgt-705-20220211-001-w-license"
     }
   }

   network_interface {
     subnetwork   = "external"
     access_config {}
   }

   network_interface {
     subnetwork   = "internal"
   }
}
```

Last but not least, you have to add information about terraform *provider* and GCP project to be used by adding a new block. Remember to replace the `my-project-1234567` placeholder with your real project id (not name). You can list all your projects using `gcloud projects list` command.

```
provider "google" {
  project = "my-project-1234567"
  region  = "us-central1"
}
```

**Note:** this example is intentionally very basic and presents a minimal terraform file. In real life you will use more terraform features like [variables](https://www.terraform.io/language/values/variables) and [references](https://www.terraform.io/language/expressions/references). You will also want to add a logdisk, define the public IP to be static (reserved for your FortiGate), [use image family](images.md#using-image-family-with-terraform) to automatically find the boot image and [use a dedicated service account](sdn_priviletes.md#terraform) with custom role to follow the least privilege principle. Check other resources in [this](../architectures/100-single-vm/terraform/single-vm-from-family) and other repositories for more complete examples.

## Deploying the template

To create the resources described by your `main.tf` file you have to run the following commands:
- `terraform init` will download and initialize all used modules (in this case `google` provider)
- `terraform plan -out my.plan` will check the syntax, show you what resources are about to be created (the *plan*) and will save the plan into a file
- `terraform apply my.plan` will execute the changes

## Deleting the resources

To delete resources created by terraform simply run `terraform destroy` in the same directory where your `main.tf` file is.
