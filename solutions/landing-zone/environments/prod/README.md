# Prod Environment

## Prod Environment Resources for Landing Zone

The following services will be deployed

| Resource | Name | Location|
| --- | --- |  --- |
| ComputeFirewall | prod-firewall-default-deny | `firewall/net-private-perimeter-firewall.yaml` |
| ComputeFirewall | computefirewall-sample-deny | `firewall/net-public-perimeter-firewall.yaml` |
| ComputeNetwork | prod-sharedvpc | `network/prod-sharedvpc.yaml` |
| ComputeSubnetwork | subnet01 | `network/prod-sharedvpc.yaml` |
| Project | ${net-host-prj-prod-id} | `network-host/network-host-project.yaml` |
| ProjectServiceSet | prod-nethost-service | `network-host/prod-nethost-services.yaml` |
| ComputeSharedVPCHostProject | computesharedvpchostproject-sample | `shared-vpc/shared-vpc.yaml` |
| AccessContextManagerAccessLevel | prodaccesslevels | `vpc-service-controls/access-policy/access-context-manager.yaml` |
