# Common Services

## Common Environment Resources for Landing Zone

| Resource | Name | Location|
| --- | --- |  --- |
| LoggingLogSink | audit-bucket-sink | `audit/audit-bucket.yaml` |
| StorageBucket | audit-${audit-prj-id} | `audit/audit-bucket.yaml` |
|  IAMPolicyMember | billing-iam-member | `audit/billing-iam-member.yaml` |
| IAMServiceAccount | billing-service-account | `audit/billing-service-account.yaml` |
| IAMPolicyMember | audit-viewer | `audit/iam.yaml` |
| IAMPolicyMember | log-reader | `audit/iam.yaml` |
| StorageBucket | log-bucket-${audit-prj-id} | `audit/log-bucket.yaml` |
| IAMPolicyMember | log-writer | `audit/log-writer-iam.yaml` |
| ComputeFirewall | allow-egress-internet-pr | `firewall/private-perimeter-firewall.yaml` |
| ComputeFirewall | allow-ssh-ingress | `firewall/private-perimeter-firewall.yaml` |
| ComputeFirewall | allow-egress-internet-pu | `firewall/public-perimeter-firewall.yaml` |
| ComputeFirewall | allow-ssh-ingressp | `firewall/public-perimeter-firewall.yaml` | IAMPolicyMember | organization-viewer | `iam/core-iam.yaml` |
| ComputeNetwork | common-ha-perimeter | `network/ha-perimeter.yaml` |
| ComputeSubnetwork | common-ha-perimeter-subnet | `network/ha-perimeter.yaml` |
| ComputeNetworkPeering | common-network-peering | `network/network-peering.yaml` |
| ComputeNetworkPeering | common-mgmt-perimeter-peer | `network/network-peering.yaml` |