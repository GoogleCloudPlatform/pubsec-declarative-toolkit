# GCP

1. add org policy exception for vm with public ip AND serial console access
2. force instance nic to be gvnic
3. instance schedule for fortigates and management vm

# Fortigate

1. add route for ip range of all peered vpc (ex. : 10.0.0.0/8) and define the internal gateway ip (ex. : 172.31.201.1) as the gateway
![route](route.png)
1. update time zone to be gmt-5
![settings](settings.png)

# setters :
- change project-id to perimeter-project-id
- schedule for all GCE

- the following secret are currently embedded into the fortigate config (GCE metadata). it would be great if it could be customized with setters.(ConfigMap, GCP secret manager/Kubernetes secrets)
  - fortigate admin pw
  - fortigate ha pw
  
---
# sample workload
## INGRESS from internet to workload
### GCP Resources
1. external ip reservation
1. forwarding rule
1. cloud armor
### Fortigate
1. VIP
1. firewall policy to allow traffic from VIP to paz subnet IP of spoke/shared workload VPC (ANTIVIRUS, IPS)
![policies](policies.png)

## Workload to common services
### Fortigate
1. address objects
1. firewall policy to allow traffic from workload vpc to paz subnet IP of spoke/shared common VPC (ANTIVIRUS, IPS)

## EGRESS workload to internet (like OS updates)
1. address objects
1. Webfilter whitelist
1. firewall policy to allow traffic from workload address to Internet (ANTIVIRUS, IPS, WEBFILTER)