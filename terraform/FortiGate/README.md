# Deployment templates for FortiGate in Google Cloud

In this directory you will find templates and reference architectures for running a FortiGate Next-Generation Firewall VM in Google Cloud (GCE).

Hint: architectures are marked with "100", "200", "300" to indicate their level of complexity and possible dependencies ("200" architectures make use of "100" and "300" architectures of "200").

## Common Architectures

### [Active-Passive HA in Load Balancer Sandwich](architectures/200-ha-active-passive-lb-sandwich/)
This design will deploy 2 FortiGate VMs in 2 zones, preconfigure an Active/Passive cluster using unicast FGCP HA protocol, and place them between a pair of external and internal load balancers. On failover load balancers will detect failure of the primary instance using active probes on port 8008 and will switch traffic to the secondary instance. The failover time is noticeably faster than using Fabric Connector and is configurable in Health Check settings. This design supports multiple public IPs.
This design is subject to 99.98% GCP Compute SLA.

<p align="center">
<img width="550px" src="https://lucid.app/publicSegments/view/a05034a9-be24-423d-b307-cf3b4efd1a0e/image.png" alt="FortiGaste A-P HA in LB Sandwich">
</p>

### [Peered Security Services Hub](architectures/300-peered-security-hub/)
GCP limitations related to deployment of multi-NIC instances make the usual architecture for deploying firewalls very static and costly (a classic 3-tier application would require an 8-core FGT instances). Peered Security Hub architecture provides flexibility of securing up to 25 LAN segments using a single internal NIC.

<p align="center">
<img width="550px" src="https://lucid.app/publicSegments/view/cdc1dc90-2ab4-4488-841a-92e2795ea630/image.png" alt="FortiGate Hub and Spoke">
</p>

## Other Architectures

### [Single VM](architectures/100-single-vm/)
A single FortiGate VM will process all the traffic. This design introduces a single point of failure, which will make some operations (e.g. upgrades) disruptive. Also, due to lower SLA (99.5%) it's rarely used as a standalone solution in production. This design can be used though as a building block for more advanced architectures.

![FGT Single VM details](https://lucid.app/publicSegments/view/4e56ef05-671c-47f3-a2cd-65cca6185f20/image.png)

### [Active-Passive HA Cluster with SDN Connector Failover](architectures/200-ha-active-passive-sdn/)
This design deploys 2 FortiGate VMs in 2 zones and preconfigure an Active/Passive cluster using unicast FGCP HA protocol. FGCP synchronizes the configuration and session table. One (directly) or more (using Protocol Forwarding) External IP addresses can be assigned to the cluster. On failover the newly active FortiGate takes control and issues API calls to GCP Compute API to shift the External IPs and update the route(s) to itself. Shifting the EIPs and routes takes about 30 seconds, but preserves existing connections.

Note: multiple IPs are available in this design with FortiGate version 7.0.2 and later.
This design is subject to 99.99% GCP Compute SLA.

<p align="center">
<img width="700px" src="https://lucid.app/publicSegments/view/09e00569-7fab-4e9f-92f1-de8fd9148623/image.png" alt="FortiGate A-P HA with SDN Connector">
</p>

### [Active-Active FGSP group](architectures/200-lb-active-active)
Active-Active design uses multiple appliances actively processing streams of data. Load balancers are used in front of each interface group to dispatch the traffic and detect unhealthy instances. Flow asymmetry impairing threat inspection can be mitigated using source NAT or FGSP L3 UTM sync feature. Connections forwarded without inspection are handled using FGSP session sync feature. Note that crash of any of the group members will cause drops of some of the existing connections.

![](https://lucid.app/publicSegments/view/e9c7ba47-30ae-43aa-b32a-bba738bedf9d/image.png)

### [IDS with Packet Mirroring](ids-packet-mirroring/)
FortiGate virtual appliances are capable of detecting and blocking threats using the FortiLabs-powered IDS/IPS system as well as the built-in antivirus engine. While it is recommended to deploy FortiGates inline, so the threats can be blocked as soon as they are detected, it is not possible to do so for the network traffic inside a Google Cloud VPC Network. In this case, one can utilize GCP Packet Mirroring feature together with FortiGate one-arm-sniffer mode to detect malicious or infected traffic and alert the administrators. For multiple sensors it's best to use FortiAnalyzer as the correlation and aggregation engine providing single pane of glass insights into the traffic patterns as well as detected threats or compromised VMs.
![](https://lucid.app/publicSegments/view/5ac9e8fb-7f7f-4077-81e8-2c1e4dc6cf51/image.png)

### [Network Connectivity Center](network-connectivity-center/)
/upcoming/

## Choosing HA Architecture
Fortinet recommends two base building blocks when designing GCP network with an Active-Passive FortiGate cluster:
1. [A-P HA with SDN Connector](architectures/200-ha-active-passive-sdn/)
2. [A-P HA in LB Sandwich](architectures/200-ha-active-passive-lb-sandwich/)

Make sure you understand differences between them and choose your architecture properly. Also remember that templates and designs provided here are the base building blocks and you can modify or mix them to match your individual use case.

| Feature | with SDN Connector | in LB Sandwich |
| --------|--------------------|----------------|
| Failover time | 30-40 secs | ~10 secs |
| Protocols supported | UDP, TCP, ICMP, ESP, AH, SCTP | TCP, UDP, ESP, GRE, ICMP, ICMPv6 |
| Max. external addresses | hundreds* (ver. 7.0.2+) / 1 (ver. 7.0.1 and earlier) | hundreds* |
| Tag-based internal GCP routes| supported | supported |
| Preserves connections during failover | yes | yes |
| SDN Connector privileges | read-write | none |

\* - subject to external forwarding rules quota per GCP project and set of forwarded protocols

## How to Deploy...
- [...using Deployment Manager](../howto-dm.md)
- [...using Terraform](../howto-tf.md)
