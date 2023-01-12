# Common Services

## Common Environment Resources for Landing Zone

The following services will be deployed

| Resource | Name | Location|
| --- | --- |  --- |
| ResourceHierarchy | landing-zone-hierarchy | `hierarchy.yaml` |
| LoggingLogSink | audit-bucket-sink | `audit/audit-bucket.yaml` |
| StorageBucket | audit-${audit-prj-id} | `audit/audit-bucket.yaml` |
| IAMPolicyMember | billing-iam-member | `audit/billing-iam-member.yaml` |
| IAMServiceAccount | billing-service-account | `audit/billing-service-account.yaml` |
| IAMPolicyMember | audit-viewer | `audit/iam.yaml` |
| IAMPolicyMember | log-reader | `audit/iam.yaml` |
| IAMPolicyMember | log-writer | `audit/log-writer-iam.yaml` |
| ComputeFirewall | allow-egress-internet-pr | `firewall/private-perimeter-firewall.yaml` |
| ComputeFirewall | allow-ssh-ingress | `firewall/private-perimeter-firewall.yaml` |
| ComputeFirewall | allow-egress-internet-pu | `firewall/public-perimeter-firewall.yaml` |
| ComputeFirewall | allow-ssh-ingressp | `firewall/public-perimeter-firewall.yaml` | IAMPolicyMember | organization-viewer | `iam/core-iam.yaml` |
| ComputeNetwork | common-ha-perimeter | `network/ha-perimeter.yaml` |
| ComputeSubnetwork | common-ha-perimeter-subnet | `network/ha-perimeter.yaml` |
| ComputeNetwork | common-mgmt-perimeter | `network/mgmt-perimeter.yaml` |
| ComputeNetworkPeering | common-network-peering | `network/network-peering.yaml` |
| ComputeNetworkPeering | common-mgmt-perimeter-peer | `network/network-peering.yaml` |
| ComputeNetworkPeering | common-prv-prm-peer | `network/network-peering.yaml` |
| ComputeNetworkPeering | public-networkpeerin | `network/network-peering.yaml` |
| ComputeNetwork | priv-perimeter | `network/private-perimeter.yaml` |
| ComputeSubnetwork | priv-perimeter-subnet | `network/private-perimeter.yaml` |
| ComputeNetwork | public-perimeter | `network/public-perimeter.yaml` |
| ComputeSubnetwork | public-perimeter-subnet | `network/public-perimeter.yaml` |
| ResourceManagerPolicy | restrict-resource-locations | `policies/org-policies.yaml` |
| ResourceManagerPolicy | disable-vpc-external-ipv6 | `policies/org-policies.yaml` |
| ResourceManagerPolicy | require-shielded-vm | `policies/org-policies.yaml` |
| ResourceManagerPolicy | require-trusted-images | `policies/org-policies.yaml` |
| ResourceManagerPolicy | restrict-vm-external-access | `policies/org-policies.yaml` |
| ResourceManagerPolicy | disable-serviceaccount-key-creation | `policies/org-policies.yaml` |
| ResourceManagerPolicy | restrict-vpc-peering | `policies/org-policies.yaml` |
| ResourceManagerPolicy | uniform-bucket-level-acces | `policies/org-policies.yaml` |
| ResourceManagerPolicy | restrict-os-login | `policies/org-policies.yaml` |
| ResourceManagerPolicy | restrict-loadbalancer-creation-types | `policies/org-policies.yaml` |
| ResourceManagerPolicy | allowed-contact-domains | `policies/org-policies.yaml` |
| ResourceManagerPolicy | allowed-policy-member-domain | `policies/org-policies.yaml` |
| ResourceManagerPolicy | disable-serial-port-access | `policies/org-policies.yaml` |
| ResourceManagerPolicy | vm-can-ip-forward | `policies/org-policies.yaml` |
| ResourceManagerPolicy | disable-guest-attribute-access | `policies/org-policies.yaml` |
| ResourceManagerPolicy | disable-nested-virtualization | `policies/org-policies.yaml` |
| ResourceManagerPolicy | restrict-vpc-lien-removal | `policies/org-policies.yaml` |
| ResourceManagerPolicy | restrict-sql-public-ip | `policies/org-policies.yaml` |
| ResourceManagerPolicy | storage-public-access-prevention | `policies/org-policies.yaml` |
| Project | ${audit-prj-id} | `projects/audit-bunker/audit-project.yaml` |
| Project | ${guardrails-project-id} | `projects/guardrails/guardrails.yaml` |
| Project | ${net-perimeter-prj-common-id} | `projects/network-perimeter/network-perimeter-project.yaml` |
| ProjectServiceSet | common-nethost-service | `projects/network-perimeter/common-network-services.yaml` |
| AccessContextManagerAccessPolicy | orgaccesspolicy | `vpc-service-controls/access-policy/access-context-manager.yaml` |
| AccessContextManagerAccessLevel | commonaccesslevels | `vpc-service-controls/access-policy/common-access-levels.yaml` |
