# Single FortiGate VM
## How to deploy using Deployment Manager

### Prerequisites
Before you deploy a FortiGate instance, you need to create
- 2 VPC Networks (external and internal)
- with 1 subnet in each

Note: subnets must be in the same region where you plan to deploy your FortiGate instance.

You also must know the following values:
1. URLs of external VPC and subnet
1. URLs of internal VPC and subnet
1. URL of image you're going to deploy (see [below](#how-to-find-the-image) for more details)
1. zone where you want to create your FortiGate VM

### Deployment steps

Deployment Manager is a declarative language describing your infrastructure as a readable code. You will have to do the following:
- create a "configuration" text file (eg. `config.yaml`)
- edit this file to describe what you want to deploy
- run gcloud command to apply changes described in the file to your GCP project

See [howto-dm.md](../../howto-dm.md) for introduction on how to use Deployment Manager.

### `config.yaml` code

Deployment Manager uses YAML file (so be careful about the line indents!) called **configuration** files to describe resources to be deployed. It's also possible to use Jinja or Python as **templates** to generate the final YAML, but in this example we will not use them. A common approach would be to use a configuration file to call a single jinja template and provide it with properties values. All resources are defined as items in the list under the `resources` key and need at least `name` and `type` subkeys with all details described under a `properties` section.

A basic code for a VM instance deploying into "us-central1-b" zone would look like below:

```
resources:
- name: my-fortigate
  type: compute.v1.instance
  properties:
    zone: us-central1-b
    machineType: zones/us-central1-b/machineTypes/e2-standard-2
    canIpForward: Yes
```

To make it a FortiGate you have to provide it with a proper boot image. Fortinet publishes images for multiple versions of firmware - read [this article](images.md) to find out how to find one. You can also upload your own image. Your resource code for firmware 7.0.5 could now look like this:

```
resources:
- name: my-fortigate
  type: compute.v1.instance
  properties:
    zone: us-central1-b
    machineType: zones/us-central1-b/machineTypes/e2-standard-2
    canIpForward: Yes
    disks:
    - deviceName: boot
      boot: true
      initializeParams:
        sourceImage: "https://www.googleapis.com/compute/v1/projects/fortigcp-project-001/global/images/fortinet-fgt-705-20220211-001-w-license"

```

Your firewall needs to be connected to some networks. GCP VM instances support a maximum of 8 NICs for VMs with at least 8 vCPUs, but Fortinet recommends using only 2 NICs for forwarding traffic: external and internal (see [Peered Security Hub](../architectures/300-peered-security-hub) architecture for information on connecting more networks). You will need additional network interfaces if deploying an HA cluster. You create network interfaces by adding items to the `networkInterface` list. Each of them needs at least a `subnetwork` link to be provided and external one can have an external IP connected by using an `accessConfig` property.

Your `fgt-vm` resource should look now like this:

```
resources:
- name: my-fortigate
  type: compute.v1.instance
  properties:
    zone: us-central1-b
    machineType: zones/us-central1-b/machineTypes/e2-standard-2
    canIpForward: Yes
    disks:
    - deviceName: boot
      boot: true
      initializeParams:
        sourceImage: "https://www.googleapis.com/compute/v1/projects/fortigcp-project-001/global/images/fortinet-fgt-705-20220211-001-w-license"
    networkInterfaces:
    - subnetwork: regions/us-central1/subnetworks/external
      accessConfigs:
      - type: ONE_TO_ONE_NAT
    - subnetwork: regions/us-central1/subnetworks/internal
```


**Note:** this example is intentionally very basic and presents a minimal deployment manager configuration. In real life you will use jinja or python to make your code [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). You will also want to add a logdisk, define the public IP to be static (reserved for your FortiGate), [use image family](images.md#using-image-family-with-deployment-manager) to automatically find the boot image and [use a dedicated service account](sdn_priviletes.md#deployment-manager) with custom role to follow the least privilege principle. Check other resources in [this](../architectures) and other repositories for more complete examples. There are also multiple templates available for you to use in [modules-dm](../modules-dm)

## Deploying the template

To create the instance described by your `config.yaml` file you have to run the following command:

`gcloud deployment-manager deployments my-deployment --config config.yaml`

## Deleting the resources

To delete resources created by terraform simply run the following command:

`gcloud deployment-manager deployments delete my-deployment`
