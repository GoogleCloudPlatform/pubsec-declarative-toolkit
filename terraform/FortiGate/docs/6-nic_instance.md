# Deploying FortiGate instance with multiple NICs
While in most cases deploying a FortiGate instance with 4 network interfaces (external, internal, heartbeat, dedicated management) is enough, in some cases you might want to use more NICs. Google Compute Engine supports up to 8 NICs depending on instance type with the rule being

Max available NICs = number of vCPUs

with minimum being 2 NICs (even for 1 vCPU instance type) and maximum being 8 NICs (even for 32 vCPU instances).

This article describes how to deploy instance with 6 NICs.

## Prerequisites
Remember that each of network interfaces of a VM instance running in GCE must be connected to a separate VPC Network and all subnets must be in the same region as your instance. Subnets in Google Cloud are regional, so even if you deploy a pair of FortiGates in different Availability Zones of the same region you can connect both VMs to the same set of subnets.

Make sure you have your VPCs and subnets created before. As default quota for VPCs is 5, this might require increasing quota for your project.

This article will use the following VPC and subnet names:

| Port | VPC | Subnet |
|------|-----|--------|
| port1 | ext-vpc | ext-sb |
| port2 | int-vpc | int-sb |
| port3 | hasync-vpc | hasync-sb |
| port4 | mgmt-vpc | mgmt-sb |
| port5 | add1-vpc | add1-sb |
| port6 | add2-vpc | add2-sb |


## Deploying using gcloud
gcloud is a native CLI tool to interact with Google Cloud services. An example command to deploy a basic 6-nic instance is:

```
gcloud compute instances create my-fortigate --zone=europe-west1-b \
  --machine-type=e2-standard-8 \
  --image-project=fortigcp-project-001 \
  --image-family=fortigate-70-byol \
  --can-ip-forward \
  --network-interface="network=ext-vpc,subnet=ext-sb" \
  --network-interface="network=int-vpc,subnet=int-sb,no-address" \
  --network-interface="network=hasync-vpc,subnet=hasync-sb,no-address" \
  --network-interface="network=mgmt-vpc,subnet=mgmt-sb" \
  --network-interface="network=add1-vpc,subnet=add1-sb,no-address" \
  --network-interface="network=add2-vpc,subnet=add2-sb,no-address"
```

As you can see - adding more `--network-interface` options adds more NICs. The `no-address` option disables an external IP address for this interface (so only external and management interfaces are available from Internet)

## Deploying with Deployment Manager
[Deployment Manager](https://cloud.google.com/deployment-manager/docs) is a native [IaC (Infrastructure-as-Code)](https://en.wikipedia.org/wiki/Infrastructure_as_code) solution from Google Cloud. While not very popular, it is the base of Google Marketplace. It's based on YAML configuration files, which might be generated using templates written in jinja and Python. A jinja or YAML file can be then deployed using gcloud CLI.

**fgt-6nics.yaml**

```
resources:
- name: my-fortigate
  type: compute.v1.instance
  properties:
    zone: europe-west1-b
    machineType: zones/europe-west1-b/machineTypes/e2-standard-8
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      licenses:
      - https://www.googleapis.com/compute/v1/projects/fortigcp-project-001/global/licenses/fortigate
      initializeParams:
        sourceImage: projects/fortigcp-project-001/global/images/family/fortinet-70-byol
        diskSizeGb: 10.0
    networkInterfaces:
    - network: global/networks/ext-vpc
      subnetwork: regions/europe-west1/subnetworks/ext-sb
      accessConfigs:
      - name: External NAT
        type: ONE_TO_ONE_NAT
    - network: global/networks/int-vpc
      subnetwork: regions/europe-west1/subnetworks/int-sb
    - network: global/networks/hasync-vpc
      subnetwork: regions/europe-west1/subnetworks/hasync-sb
    - network: global/networks/mgmt-vpc
      subnetwork: regions/europe-west1/subnetworks/mgmt-sb
      accessConfigs:
      - name: Management
        type: ONE_TO_ONE_NAT
    - network: global/networks/add1-vpc
      subnetwork: regions/europe-west1/subnetworks/add1-sb
    - network: global/networks/add2-vpc
      subnetwork: regions/europe-west1/subnetworks/add2-sb      
    canIpForward: Yes
```

```
gcloud deployment-manager deployments create my-deployment --config fgt-6nics.yaml
```

## Deploying with Terraform
[Terraform](https://www.terraform.io/) is a popular [IaC (Infrastructure-as-Code)](https://en.wikipedia.org/wiki/Infrastructure_as_code) tool which can be used to create, modify and destroy infrastructure in many different public and private clouds. If you're serious about public cloud you **definitely should** find time to learn it.

**main.tf**

```
provider "google" {
  project = [YOU GCP PROJECT NAME]
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

data "google_compute_image" "fgt_image" {
  project = "fortigcp-project-001"
  family  = "fortigate-70-byol"
}

resource "google_compute_instance" "fgt-vm" {
  name         = "my-fortigate"
  machine_type = "e2-standard-8"
  can_ip_forward = true

  boot_disk {
    initialize_params {
      image = data.google_compute_image.fgt_image.self_link
    }
  }

  network_interface {
    subnetwork = "ext-sb"
    access_config {}
  }
  network_interface {
    subnetwork = "int-sb"
  }
  network_interface {
    subnetwork = "hasync-sb"
  }
  network_interface {
    subnetwork = "mgmt-sb"
    access_config {}
  }
  network_interface {
    subnetwork = "add1-sb"
  }
  network_interface {
    subnetwork = "add2-sb"
  }
}
```

```
terraform init
terraform apply
```
