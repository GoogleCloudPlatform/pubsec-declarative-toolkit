# NonProd Environment

## NonProd Environment Resources for Landing Zone

The following services will be deployed

| Resource | Name | Location|
| --- | --- |  --- |
| ComputeFirewall | allow-egress-internet | `firewall/firewall.yaml` |
| ComputeFirewall | allow-ssh-ingress | `firewall/firewall.yaml` |
| ComputeNetwork | nonprod-sharedvpc | `network/non-prod-network.yaml` |
| ComputeSubnetwork | nonprod-sharedvpc-subnet | `network/non-prod-network.yaml` |
| Project | ${net-host-prj-nonprod-id} | `projects/network-host/network-host-project.yaml` |
| ComputeProjectMetadata | nonprod-oslogin-meta | `projects/network-host/network-host-project.yaml` |
| ProjectServiceSet | nonprod-nethost-service | `projects/network-host/nonprod-network-host-services.yaml` |
| ComputeSharedVPCHostProject | nonprod-shared-vpc-host | `shared-vpc/shared-vpc.yaml` |
| AccessContextManagerAccessLevel | nonprodperimaccesslevel | `access-policy/access-context-manager.yaml` |
