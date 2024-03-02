# Active-Passive HA FortiGate cluster in LB Sandwich
This template deploys 2 FortiGate instances in an Active-Passive HA cluster between two load balancers ("load balancer sandwich" pattern). LB Sandwich design enables use of multiple public IPs and provides faster, configurable failover times when compared to SDN-connector based. External Network Load Balancer configuration in this template uses L3_DEFAULT protocol to support broad range or protocols (TCP, UDP, ESP, GRE, ICMP, and ICMPv6) and Connection Tracking to enable stateful failover of existing TCP sessions.

HA multi-zone deployments provide 99.98% Compute Engine SLA vs. 99.5% for single instances. See [Google Compute Engine SLA](https://cloud.google.com/compute/sla) for details.

* Deployment Manager Template file: [modules/fgcp-ha-ap-elbilb.jinja](../modules/deployment-manager/fgcp-ha-ap-elbilb.jinja)
* Deployment Manager Schema file: [modules/fgcp-ha-ap-elbilb.jinja.schema](../modules/deployment-manager/fgcp-ha-ap-elbilb.jinja.schema)
* Terraform module: [https://github.com/40net-cloud/fortigate-gcp-ha-ap-lb-terraform](https://github.com/40net-cloud/fortigate-gcp-ha-ap-lb-terraform)

## Overview
FortiGate Clustering Protocol (FGCP) natively does not work in L3 overlay networks. For cloud deployments it must be configured to use unicast communication, which slightly limits its functionality (only Active-Passive between 2 peers is possible) and enforces use of dedicated management interface. In this template port3 is used as heartbeat and FGCP sync interface and port4 is used as dedicated management interface (versions 7.0.1 and later allow usng single NIC for heartbeat and management, btu it's not supported by the templates in this repo yet).

As cloud networks do not allow any network mechanisms below IP layer (e.g. gratuitous arp) usually used in HA scenarios, this template adds a pair of load balancers and configures health probes to detect currently active instance. Passive peer will be detected as unhealthy by the load balancers and will not receive any traffic. External load balancer is configured to forward all UDP and all TCP ports, while internal load balancer is used as a next hop in the custom route (note that despite using a single port in the ILB, it will route all UDP, TCP and ICMP traffic).

## Active-Passive HA Design Options Comparison
Read [here](../../README.md#choosing-ha-architecture) more about differences between different HA designs in Google Cloud.

## Diagram
As unicast FGCP clustering of FortiGate instances requires dedicated heartbeat and management NICs, 2 additional VPC Networks need to be created (or indicated in configuration file). This design features 4 separate VPCs for external, internal, heartbeat and management NICs. Both instances are deployed in separate zones indicated in **zones** property to enable GCP 99.99% SLA. Note that newer firmware versions (7.0+) support using the same NIC for heartbeat and management.

Additional resources deployed include:
- default route for the internal VPC Network pointing to the internal load balancer rule
- external IPs - by default one floating IP for incoming traffic from Internet and 2 management IPs, to add more external IPs simply list them in the **publicIPs** property
- Cloud Router/Cloud NAT service is used to allow outbound traffic from port1 of FortiGate instance (e.g. for license activation)

![ELBILB Sandwich diagram](https://lucid.app/publicSegments/view/190fc808-660a-4094-aeb7-c3ef4ebcb2c5/image.png)

## Deployed Resources
- 2 FortiGate VM instances with 4 NICs each
- 2 VPC Networks: heartbeat and management (unless provided)
- 2 unmanaged Instance Groups (one in each zone)
- HTTP Health Check
- External Load Balancer
    - External addresses
    - Backend Service
    - 1 Forwarding Rule for each external address
- Internal Load Balancer
    - Backend Service
    - Internal Forwarding Rule (using ephemeral internal IP)
    - route(s) via Forwarding Rule
- Cloud NAT

## How to deploy
- [using Deployment Manager](deployment-manager/)
- [using Terrform](terraform/)

## See also
[Other FortiGate designs](../../README.md)
