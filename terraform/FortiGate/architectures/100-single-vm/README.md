# Single FortiGate VM

Single VM is a basic setup good to start exploring capabilities of the next-generation firewall and a base layer for more advanced architectures. It will allow you to protect your workloads running in Google Cloud as well as inspect the outbound traffic, but - as a single VM is subject to lower GCP Compute SLA (99.5%) - it is very rarely used as a production architecture.

## Design

![FGT Single VM details](https://lucid.app/publicSegments/view/4e56ef05-671c-47f3-a2cd-65cca6185f20/image.png)

A single FortiGate VM instance with 2 network interfaces in external and internal VPC. Although it is technically possible to deploy with just one NIC, Fortinet recommends using port1 as external interface and port2 as internal for convenience.

External NIC (port1) is connected to Internet using its public IP address and optionally can use protocol forwarding to utilize more external addresses. It is the primary network interface from the point of view of the cloud and will be also used for communication with Google Cloud metadata server (169.254.169.254)

Internal NIC (port2) is configured as target for a custom route added to internal VPC Network, which causes all outbound traffic to be routed via FortiGate appliance.

## Deploying a single FortiGate VM

- [with Deployment Manager](deployment-manager/)
- [with Terraform](terraform/)
- [with gcloud utility](deploy-gcloud.md)
