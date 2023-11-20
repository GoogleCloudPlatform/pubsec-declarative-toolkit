<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# core-landing-zone


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing Zone v2 core package.
Depends on the bootstrap procedure.

[Deploy a landing zone v2](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/docs/landing-zone-v2).

Attention, validate impact with CCCS Cloud Based Sensors before implementing any changes to organization policies.

## Setters

|                         Name                          |                  Value                  | Type  | Count |
|-------------------------------------------------------|-----------------------------------------|-------|-------|
| allowed-contact-domains                               | ["@example.com"]                        | array |     1 |
| allowed-load-balancer-types                           | [INTERNAL_HTTP_HTTPS, INTERNAL_TCP_UDP] | array |     1 |
| allowed-policy-domain-members                         | ["DIRECTORY_CUSTOMER_ID"]               | array |     1 |
| allowed-trusted-image-projects                        | ["projects/cos-cloud"]                  | array |     1 |
| allowed-vpc-peering                                   | ["under:organizations/ORGANIZATION_ID"] | array |     1 |
| billing-id                                            | AAAAAA-BBBBBB-CCCCCC                    | str   |     2 |
| dns-name                                              | example.com.                            | str   |     1 |
| dns-project-id                                        | dns-project-12345                       | str   |     8 |
| logging-project-id                                    | logging-project-12345                   | str   |    27 |
| lz-folder-id                                          |                              0000000000 | str   |    14 |
| management-namespace                                  | config-control                          | str   |    43 |
| management-project-id                                 | management-project-12345                | str   |    79 |
| management-project-number                             |                              0000000000 | str   |     3 |
| org-id                                                |                              0000000000 | str   |    42 |
| platform-and-component-log-bucket                     | platform-and-component-log-bucket-12345 | str   |     2 |
| retention-in-days                                     |                                       1 | int   |     2 |
| retention-locking-policy                              | false                                   | bool  |     2 |
| security-incident-log-bucket                          | security-incident-log-bucket-12345      | str   |     1 |
| security-incident-log-bucket-retention-in-seconds     |                                   86400 | int   |     1 |
| security-incident-log-bucket-retention-locking-policy | false                                   | bool  |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|                                         File                                          |                  APIVersion                   |          Kind          |                                   Name                                    |     Namespace     |
|---------------------------------------------------------------------------------------|-----------------------------------------------|------------------------|---------------------------------------------------------------------------|-------------------|
| lz-folder/audits/folder.yaml                                                          | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                 | audits                                                                    | hierarchy         |
| lz-folder/audits/logging-project/cloud-logging-buckets.yaml                           | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogBucket       | security-log-bucket                                                       | logging           |
| lz-folder/audits/logging-project/cloud-logging-buckets.yaml                           | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogBucket       | platform-and-component-log-bucket                                         | logging           |
| lz-folder/audits/logging-project/cloud-storage-buckets.yaml                           | storage.cnrm.cloud.google.com/v1beta1         | StorageBucket          | security-incident-log-bucket                                              | logging           |
| lz-folder/audits/logging-project/project-iam.yaml                                     | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | security-log-bucket-writer-permissions                                    | projects          |
| lz-folder/audits/logging-project/project-iam.yaml                                     | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | platform-and-component-services-log-bucket-writer-permissions             | projects          |
| lz-folder/audits/logging-project/project-iam.yaml                                     | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | platform-and-component-services-infra-log-bucket-writer-permissions       | projects          |
| lz-folder/audits/logging-project/project-iam.yaml                                     | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | mgmt-project-cluster-platform-and-component-log-bucket-writer-permissions | projects          |
| lz-folder/audits/logging-project/project-iam.yaml                                     | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | logging-project-id-logging-sa-storageadmin-permissions                    | projects          |
| lz-folder/audits/logging-project/project-iam.yaml                                     | iam.cnrm.cloud.google.com/v1beta1             | IAMAuditConfig         | logging-project-data-access-log-config                                    | projects          |
| lz-folder/audits/logging-project/project-sink.yaml                                    | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink         | logging-project-id-data-access-sink                                       | logging           |
| lz-folder/audits/logging-project/project.yaml                                         | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project                | logging-project-id                                                        | projects          |
| lz-folder/clients/folder.yaml                                                         | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                 | clients                                                                   | hierarchy         |
| lz-folder/services/folder-sink.yaml                                                   | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink         | platform-and-component-services-log-sink                                  | logging           |
| lz-folder/services/folder.yaml                                                        | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                 | services                                                                  | hierarchy         |
| lz-folder/services-infrastructure/dns-project/dns.yaml                                | dns.cnrm.cloud.google.com/v1beta1             | DNSManagedZone         | dns-project-id-standard-core-public-dns                                   | networking        |
| lz-folder/services-infrastructure/dns-project/project.yaml                            | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project                | dns-project-id                                                            | projects          |
| lz-folder/services-infrastructure/dns-project/services.yaml                           | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | dns-project-id-dns                                                        | projects          |
| lz-folder/services-infrastructure/folder-sink.yaml                                    | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink         | platform-and-component-services-infra-log-sink                            | logging           |
| lz-folder/services-infrastructure/folder.yaml                                         | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                 | services-infrastructure                                                   | hierarchy         |
| mgmt-project/org-policies/compute-disable-serial-port-logging-except-mgt-project.yaml | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-disable-serial-port-logging-except-mgt-project                    | policies          |
| mgmt-project/org-policies/compute-require-shielded-vm-except-mgmt-project.yaml        | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-require-shielded-vm-except-mgt-project                            | policies          |
| mgmt-project/org-policies/compute-restrict-cloud-nat-usage-except-mgt-project.yaml    | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-restrict-cloud-nat-usage-except-mgt-project                       | policies          |
| mgmt-project/project-sink.yaml                                                        | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink         | mgmt-project-cluster-platform-and-component-log-sink                      | logging           |
| mgmt-project/services.yaml                                                            | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | management-project-id-cloudbilling                                        | config-control    |
| mgmt-project/services.yaml                                                            | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | management-project-id-cloudresourcemanager                                | config-control    |
| mgmt-project/services.yaml                                                            | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | management-project-id-serviceusage                                        | config-control    |
| mgmt-project/services.yaml                                                            | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | management-project-id-accesscontextmanager                                | config-control    |
| namespaces/gatekeeper-system.yaml                                                     | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | gatekeeper-admin-sa                                                       | config-control    |
| namespaces/gatekeeper-system.yaml                                                     | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | gatekeeper-admin-sa-metric-writer-permissions                             | config-control    |
| namespaces/gatekeeper-system.yaml                                                     | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | gatekeeper-admin-sa-workload-identity-binding                             | config-control    |
| namespaces/gatekeeper-system.yaml                                                     | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                         | gatekeeper-system |
| namespaces/hierarchy.yaml                                                             | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | hierarchy-sa                                                              | config-control    |
| namespaces/hierarchy.yaml                                                             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | hierarchy-sa-folderadmin-permissions                                      | config-control    |
| namespaces/hierarchy.yaml                                                             | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | hierarchy-sa-workload-identity-binding                                    | config-control    |
| namespaces/hierarchy.yaml                                                             | v1                                            | Namespace              | hierarchy                                                                 |                   |
| namespaces/hierarchy.yaml                                                             | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                         | hierarchy         |
| namespaces/hierarchy.yaml                                                             | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-hierarchy-resource-reference-from-projects                          | hierarchy         |
| namespaces/hierarchy.yaml                                                             | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-hierarchy-resource-reference-from-policies                          | hierarchy         |
| namespaces/hierarchy.yaml                                                             | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-hierarchy-resource-reference-from-config-control                    | hierarchy         |
| namespaces/hierarchy.yaml                                                             | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-folders-resource-reference-to-logging                               | hierarchy         |
| namespaces/logging.yaml                                                               | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | logging-sa                                                                | config-control    |
| namespaces/logging.yaml                                                               | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | logging-sa-logadmin-permissions                                           | config-control    |
| namespaces/logging.yaml                                                               | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | logging-sa-workload-identity-binding                                      | config-control    |
| namespaces/logging.yaml                                                               | v1                                            | Namespace              | logging                                                                   |                   |
| namespaces/logging.yaml                                                               | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                         | logging           |
| namespaces/logging.yaml                                                               | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-logging-resource-reference-from-projects                            | logging           |
| namespaces/management-namespace.yaml                                                  | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | config-control-sa-orgroleadmin-permissions                                | config-control    |
| namespaces/management-namespace.yaml                                                  | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | config-control-sa-management-project-editor-permissions                   | config-control    |
| namespaces/management-namespace.yaml                                                  | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | config-control-sa-management-project-serviceaccountadmin-permissions      | config-control    |
| namespaces/networking.yaml                                                            | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | networking-sa                                                             | config-control    |
| namespaces/networking.yaml                                                            | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-networkadmin-permissions                                    | config-control    |
| namespaces/networking.yaml                                                            | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-security-permissions                                        | config-control    |
| namespaces/networking.yaml                                                            | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-dns-permissions                                             | config-control    |
| namespaces/networking.yaml                                                            | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-service-control-org-permissions                             | config-control    |
| namespaces/networking.yaml                                                            | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-xpnadmin-permissions                                        | config-control    |
| namespaces/networking.yaml                                                            | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-servicedirectoryeditor-permissions                          | config-control    |
| namespaces/networking.yaml                                                            | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | networking-sa-workload-identity-binding                                   | config-control    |
| namespaces/networking.yaml                                                            | v1                                            | Namespace              | networking                                                                |                   |
| namespaces/networking.yaml                                                            | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                         | networking        |
| namespaces/policies.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | policies-sa                                                               | config-control    |
| namespaces/policies.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | policies-sa-orgpolicyadmin-permissions                                    | config-control    |
| namespaces/policies.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | policies-sa-workload-identity-binding                                     | config-control    |
| namespaces/policies.yaml                                                              | v1                                            | Namespace              | policies                                                                  |                   |
| namespaces/policies.yaml                                                              | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                         | policies          |
| namespaces/projects.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | projects-sa                                                               | config-control    |
| namespaces/projects.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | projects-sa-projectiamadmin-permissions                                   | config-control    |
| namespaces/projects.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | projects-sa-projectcreator-permissions                                    | config-control    |
| namespaces/projects.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | projects-sa-projectmover-permissions                                      | config-control    |
| namespaces/projects.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | projects-sa-projectdeleter-permissions                                    | config-control    |
| namespaces/projects.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | projects-sa-serviceusageadmin-permissions                                 | config-control    |
| namespaces/projects.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | projects-sa-billinguser-permissions                                       | config-control    |
| namespaces/projects.yaml                                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | projects-sa-workload-identity-binding                                     | config-control    |
| namespaces/projects.yaml                                                              | v1                                            | Namespace              | projects                                                                  |                   |
| namespaces/projects.yaml                                                              | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                         | projects          |
| namespaces/projects.yaml                                                              | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-projects-resource-reference-from-logging                            | projects          |
| namespaces/projects.yaml                                                              | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-projects-resource-reference-from-networking                         | projects          |
| namespaces/projects.yaml                                                              | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-projects-resource-reference-from-policies                           | projects          |
| org/custom-roles/gke-firewall-admin.yaml                                              | iam.cnrm.cloud.google.com/v1beta1             | IAMCustomRole          | gke-firewall-admin                                                        | config-control    |
| org/custom-roles/tier2-dnsrecord-admin.yaml                                           | iam.cnrm.cloud.google.com/v1beta1             | IAMCustomRole          | tier2-dnsrecord-admin                                                     | config-control    |
| org/custom-roles/tier2-vpcpeering-admin.yaml                                          | iam.cnrm.cloud.google.com/v1beta1             | IAMCustomRole          | tier2-vpcpeering-admin                                                    | config-control    |
| org/custom-roles/tier3-dnsrecord-admin.yaml                                           | iam.cnrm.cloud.google.com/v1beta1             | IAMCustomRole          | tier3-dnsrecord-admin                                                     | config-control    |
| org/custom-roles/tier3-firewallrule-admin.yaml                                        | iam.cnrm.cloud.google.com/v1beta1             | IAMCustomRole          | tier3-firewallrule-admin                                                  | config-control    |
| org/custom-roles/tier3-subnetwork-admin.yaml                                          | iam.cnrm.cloud.google.com/v1beta1             | IAMCustomRole          | tier3-subnetwork-admin                                                    | config-control    |
| org/custom-roles/tier3-vpcsc-admin.yaml                                               | iam.cnrm.cloud.google.com/v1beta1             | IAMCustomRole          | tier3-vpcsc-admin                                                         | config-control    |
| org/custom-roles/tier4-secretmanager-admin.yaml                                       | iam.cnrm.cloud.google.com/v1beta1             | IAMCustomRole          | tier4-secretmanager-admin                                                 | config-control    |
| org/org-policies/compute-disable-guest-attribute-access.yaml                          | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-disable-guest-attribute-access                                    | policies          |
| org/org-policies/compute-disable-nested-virtualization.yaml                           | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-disable-nested-virtualization                                     | policies          |
| org/org-policies/compute-disable-serial-port-access.yaml                              | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-disable-serial-port-access                                        | policies          |
| org/org-policies/compute-disable-serial-port-logging.yaml                             | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-disable-serial-port-logging                                       | policies          |
| org/org-policies/compute-disable-vpc-external-ipv6.yaml                               | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-disable-vpc-external-ipv6                                         | policies          |
| org/org-policies/compute-require-os-login.yaml                                        | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-require-os-login                                                  | policies          |
| org/org-policies/compute-require-shielded-vm.yaml                                     | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-require-shielded-vm                                               | policies          |
| org/org-policies/compute-restrict-cloud-nat-usage.yaml                                | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-restrict-cloud-nat-usage                                          | policies          |
| org/org-policies/compute-restrict-load-balancer-creation-for-types.yaml               | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-restrict-load-balancer-creation-for-types                         | policies          |
| org/org-policies/compute-restrict-shared-vpc-lien-removal.yaml                        | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-restrict-shared-vpc-lien-removal                                  | policies          |
| org/org-policies/compute-restrict-vpc-peering.yaml                                    | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-restrict-vpc-peering                                              | policies          |
| org/org-policies/compute-restrict-vpn-peer-ips.yaml                                   | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-restrict-vpn-peer-ips                                             | policies          |
| org/org-policies/compute-skip-default-network-creation.yaml                           | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-skip-default-network-creation                                     | policies          |
| org/org-policies/compute-trusted-image-projects.yaml                                  | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-trusted-image-projects                                            | policies          |
| org/org-policies/compute-vm-can-ip-forward.yaml                                       | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-vm-can-ip-forward                                                 | policies          |
| org/org-policies/compute-vm-external-ip-access.yaml                                   | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-vm-external-ip-access                                             | policies          |
| org/org-policies/essentialcontacts-allowed-contact-domains.yaml                       | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | essentialcontacts-allowed-contact-domains                                 | policies          |
| org/org-policies/gcp-resource-locations.yaml                                          | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | gcp-restrict-resource-locations                                           | policies          |
| org/org-policies/iam-allowed-policy-member-domains.yaml                               | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | iam-allowed-policy-member-domains                                         | policies          |
| org/org-policies/iam-automatic-iam-grants-for-default-service-accounts.yaml           | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | iam-automatic-iam-grants-for-default-service-accounts                     | policies          |
| org/org-policies/iam-disable-audit-logging-exemption.yaml                             | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | iam-disable-audit-logging-exemption                                       | policies          |
| org/org-policies/iam-disable-service-account-key-creation.yaml                        | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | iam-disable-service-account-key-creation                                  | policies          |
| org/org-policies/iam-disable-service-account-key-upload.yaml                          | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | iam-disable-service-account-key-upload                                    | policies          |
| org/org-policies/sql-restrict-public-ip.yaml                                          | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | sql-restrict-public-ip                                                    | policies          |
| org/org-policies/storage-public-access-prevention.yaml                                | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | storage-public-access-prevention                                          | policies          |
| org/org-policies/storage-uniform-bucket-level-access.yaml                             | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | storage-uniform-bucket-level-access                                       | policies          |
| org/org-sink.yaml                                                                     | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink         | org-log-sink-security-logging-project-id                                  | logging           |
| org/org-sink.yaml                                                                     | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink         | org-log-sink-data-access-logging-project-id                               | logging           |

## Resource References

- [ConfigConnectorContext](https://cloud.google.com/config-connector/docs/how-to/advanced-install#addon-configuring)
- [DNSManagedZone](https://cloud.google.com/config-connector/docs/reference/resource-docs/dns/dnsmanagedzone)
- [Folder](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/folder)
- [IAMAuditConfig](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamauditconfig)
- [IAMCustomRole](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamcustomrole)
- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [IAMServiceAccount](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamserviceaccount)
- [LoggingLogBucket](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogbucket)
- [LoggingLogSink](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogsink)
- [Namespace](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#namespace-v1-core)
- [Project](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/project)
- [ResourceManagerPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/resourcemanagerpolicy)
- [RoleBinding](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#rolebinding-v1-rbac-authorization-k8s-io)
- [Service](https://cloud.google.com/config-connector/docs/reference/resource-docs/serviceusage/service)
- [StorageBucket](https://cloud.google.com/config-connector/docs/reference/resource-docs/storage/storagebucket)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/core-landing-zone@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./core-landing-zone/"
    ```

1.  Edit the function config file(s):
    - setters.yaml

1.  Execute the function pipeline
    ```shell
    kpt fn render
    ```

1.  Initialize the resource inventory
    ```shell
    kpt live init --namespace ${NAMESPACE}
    ```
    Replace `${NAMESPACE}` with the namespace in which to manage
    the inventory ResourceGroup (for example, `config-control`).

1.  Apply the package resources to your cluster
    ```shell
    kpt live apply
    ```

1.  Wait for the resources to be ready
    ```shell
    kpt live status --output table --poll-until current
    ```

<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
