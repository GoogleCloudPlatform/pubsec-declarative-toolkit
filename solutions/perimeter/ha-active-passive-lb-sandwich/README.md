# HA Active-Passive

This template deploys 2 Fortigate instances in an Active-Passive HA cluster between two load balancers ("load balancer sandwich" pattern). LB Sandwich design enables use of multiple public IPs and provides faster, configurable failover times. HA multi-zone deployments provide 99.99% Compute Engine SLA.

![Image of HA Active/Passive](/GCP/examples/ha-active-passive-lb-sandwich/HA-A-P-Sandwich.png)


## Resources included in this Example

1. 4 VPC Networks
    - Public/External/Untrust
    - Private/Internal/Trust
    - Sync
    - Management
1. Subnets for each VPC Network
    - Public
    - Private
    - Sync
    - Management
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowgin all protocols.
1. 2 Instances
    - Active
        - Deploys License
        - Updates Password
        - Configures HA
        - Configures GCP SDN Connector
    - Passive
        - Deploys License
        - Updates Password
        - Configures HA
        - Configures GCP SDN Connector
1. External Load Balancer
1. 2 External Computer Address (Static IPs)
1. Target Pool
1. Legacy Health Check
1. 2 Forwarding Rules for each IP (UDP and TCP)
1. Internal Load Balancer
1. 2 unmanaged Instance Groups (one in each zone)
1. Backend Service
1. Internal Forwarding Rule
1. Internal Compute Address (Internal Static IP)
1. HTTP Health Check
1. Route via Forwarding Rule
1. Cloud NAT

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in required variables that don't have a default. (CREDENTIALS, GCP_PROJECT, SERVICE_ACCOUNT_EMAIL, IMAGE, LICENSE_FILE)
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
