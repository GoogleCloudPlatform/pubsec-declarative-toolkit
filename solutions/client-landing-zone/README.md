<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# client-landing-zone


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Depends on `client-setup`.

Package to create a client's folder hierarchy, logging resources and a network host project.

## Setters

|                 Name                 |                                                                                                                         Value                                                                                                                          | Type  | Count |
|--------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------|
| allowed-os-update-domains            | ["debian.map.fastlydns.net", "debian.org", "deb.debian.org", "ubuntu.com", "cloud.google.com", "packages.cloud.google.com", "security.ubuntu.com", "northamerica-northeast1.gce.archive.ubuntu.com", "northamerica-northeast2.gce.archive.ubuntu.com"] | array |     1 |
| allowed-os-update-source-ip-ranges   | ["10.1.0.0/21", "10.1.8.0/21", "10.1.32.0/19", "10.1.128.0/21", "10.1.136.0/21", "10.1.160.0/19"]                                                                                                                                                      | array |     1 |
| client-billing-id                    | AAAAAA-BBBBBB-CCCCCC                                                                                                                                                                                                                                   | str   |     1 |
| client-folderviewer                  | group:client1@example.com                                                                                                                                                                                                                              | str   |     1 |
| client-name                          | client1                                                                                                                                                                                                                                                | str   |   186 |
| denied-sanctioned-countries          | ["XX"]                                                                                                                                                                                                                                                 | array |     1 |
| dns-name                             | client-name.example.com.                                                                                                                                                                                                                               | str   |     2 |
| dns-nameservers                      | ["ns-cloud-a1.googledomains.com.", "ns-cloud-a2.googledomains.com.", "ns-cloud-a3.googledomains.com.", "ns-cloud-a4.googledomains.com."]                                                                                                               | array |     1 |
| dns-project-id                       | dns-project-12345                                                                                                                                                                                                                                      | str   |     2 |
| firewall-internal-ip-ranges          | [10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16]                                                                                                                                                                                                            | array |     5 |
| host-project-id                      | net-host-project-12345                                                                                                                                                                                                                                 | str   |   115 |
| logging-project-id                   | logging-project-12345                                                                                                                                                                                                                                  | str   |     2 |
| project-allowed-restrict-vpc-peering | [under:projects/PROJECT_ID]                                                                                                                                                                                                                            | array |     0 |
| retention-in-days                    |                                                                                                                                                                                                                                                      1 | int   |     1 |
| retention-locking-policy             | false                                                                                                                                                                                                                                                  | bool  |     1 |
| standard-nane1-nonp-main-snet        | 10.1.0.0/21                                                                                                                                                                                                                                            | str   |     1 |
| standard-nane1-pbmm-main-snet        | 10.1.128.0/21                                                                                                                                                                                                                                          | str   |     1 |
| standard-nane2-nonp-main-snet        | 10.1.8.0/21                                                                                                                                                                                                                                            | str   |     1 |
| standard-nane2-pbmm-main-snet        | 10.1.136.0/21                                                                                                                                                                                                                                          | str   |     1 |
| standard-nonp-cidr                   | [10.1.0.0/18, 172.16.0.0/13]                                                                                                                                                                                                                           | array |     2 |
| standard-pbmm-cidr                   | [10.1.128.0/18, 172.24.0.0/13]                                                                                                                                                                                                                         | array |     2 |

## Sub-packages

This package has no sub-packages.

## Resources

|                                                                       File                                                                        |                  APIVersion                   |               Kind               |                                             Name                                             |       Namespace        |
|---------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|----------------------------------|----------------------------------------------------------------------------------------------|------------------------|
| client-folder/firewall-policy/policy.yaml                                                                                                         | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicy            | client-name-client-folder-fwpol                                                              | client-name-networking |
| client-folder/firewall-policy/policy.yaml                                                                                                         | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyAssociation | client-name-client-folder-fwpol-association                                                  | client-name-networking |
| client-folder/firewall-policy/rules/defaults.yaml                                                                                                 | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-client-folder-fwpol-exclude-private-ip-ranges-egress-fwr                         | client-name-networking |
| client-folder/firewall-policy/rules/defaults.yaml                                                                                                 | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-client-folder-fwpol-exclude-private-ip-ranges-ingress-fwr                        | client-name-networking |
| client-folder/firewall-policy/rules/defaults.yaml                                                                                                 | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-client-folder-fwpol-deny-tor-nodes-ingress-traffic-fwr                           | client-name-networking |
| client-folder/firewall-policy/rules/defaults.yaml                                                                                                 | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-client-folder-fwpol-deny-sanctioned-countries-ingress-fwr                        | client-name-networking |
| client-folder/firewall-policy/rules/iap.yaml                                                                                                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-client-folder-fwpol-goto-next-for-iap-fwr                                        | client-name-networking |
| client-folder/firewall-policy/rules/lb-health-checks.yaml                                                                                         | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-client-folder-fwpol-goto-next-for-lb-health-checks-fwr                           | client-name-networking |
| client-folder/firewall-policy/rules/os-updates.yaml                                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-client-folder-fwpol-allow-os-updates-fwr                                         | client-name-networking |
| client-folder/folder-iam.yaml                                                                                                                     | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember                  | clients.client-name-client-folder-viewer-permissions                                         | client-name-hierarchy  |
| client-folder/folder-sink.yaml                                                                                                                    | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink                   | platform-and-component-log-client-name-log-sink                                              | logging                |
| client-folder/standard/applications/folder.yaml                                                                                                   | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                           | standard.applications                                                                        | client-name-hierarchy  |
| client-folder/standard/applications/nonp/folder.yaml                                                                                              | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                           | standard.applications.nonp                                                                   | client-name-hierarchy  |
| client-folder/standard/applications/pbmm/folder.yaml                                                                                              | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                           | standard.applications.pbmm                                                                   | client-name-hierarchy  |
| client-folder/standard/applications-infrastructure/firewall-policy/policy.yaml                                                                    | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicy            | client-name-standard-applications-infrastructure-fwpol                                       | client-name-networking |
| client-folder/standard/applications-infrastructure/firewall-policy/policy.yaml                                                                    | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyAssociation | client-name-standard-applications-infrastructure-fwpol-association                           | client-name-networking |
| client-folder/standard/applications-infrastructure/firewall-policy/rules/defaults.yaml                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-standard-applications-infrastructure-fwpol-exclude-private-ip-ranges-egress-fwr  | client-name-networking |
| client-folder/standard/applications-infrastructure/firewall-policy/rules/defaults.yaml                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-standard-applications-infrastructure-fwpol-exclude-private-ip-ranges-ingress-fwr | client-name-networking |
| client-folder/standard/applications-infrastructure/firewall-policy/rules/defaults.yaml                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-standard-applications-infrastructure-fwpol-deny-known-malicious-ip-ingress-fwr   | client-name-networking |
| client-folder/standard/applications-infrastructure/firewall-policy/rules/defaults.yaml                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-standard-applications-infrastructure-fwpol-deny-known-malicious-ip-egress-fwr    | client-name-networking |
| client-folder/standard/applications-infrastructure/firewall-policy/rules/iap.yaml                                                                 | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-standard-applications-infrastructure-fwpol-goto-next-for-iap-fwr                 | client-name-networking |
| client-folder/standard/applications-infrastructure/firewall-policy/rules/lb-health-checks.yaml                                                    | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-standard-applications-infrastructure-fwpol-goto-next-for-lb-health-checks-fwr    | client-name-networking |
| client-folder/standard/applications-infrastructure/folder.yaml                                                                                    | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                           | standard.applications-infrastructure                                                         | client-name-hierarchy  |
| client-folder/standard/applications-infrastructure/host-project/network/dnspolicy.yaml                                                            | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy                        | host-project-id-standard-logging-dnspolicy                                                   | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml                                                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall                  | host-project-id-standard-egress-allow-all-internal-fwr                                       | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml                                                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall                  | host-project-id-standard-default-egress-deny-fwr                                             | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml                                                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall                  | host-project-id-standard-default-ingress-deny-fwr                                            | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/nat.yaml                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouterNAT                 | host-project-id-nane1-nat                                                                    | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/nat.yaml                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouter                    | host-project-id-nane1-router                                                                 | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/nat.yaml                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouterNAT                 | host-project-id-nane2-nat                                                                    | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/nat.yaml                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouter                    | host-project-id-nane2-router                                                                 | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSManagedZone                   | host-project-id-standard-googleapis-dns                                                      | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                     | host-project-id-standard-googleapis-rset                                                     | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                     | host-project-id-standard-googleapis-wildcard-rset                                            | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSManagedZone                   | host-project-id-standard-gcrio-dns                                                           | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                     | host-project-id-standard-gcrio-rset                                                          | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                     | host-project-id-standard-gcrio-wildcard-rset                                                 | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/firewall.yaml                                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall                  | host-project-id-standard-egress-allow-psc-fwr                                                | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/psc.yaml                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress                   | host-project-id-standard-psc-apis-ip                                                         | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/psc.yaml                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeForwardingRule            | host-project-id-standard-psc-apis-fw                                                         | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/public-dns.yaml                                                           | dns.cnrm.cloud.google.com/v1beta1             | DNSManagedZone                   | client-name-standard-public-dns                                                              | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/public-dns.yaml                                                           | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                     | client-name-standard-core-public-dns-ns-rset                                                 | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork                | host-project-id-nane1-standard-nonp-main-snet                                                | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork                | host-project-id-nane1-standard-pbmm-main-snet                                                | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork                | host-project-id-nane2-standard-nonp-main-snet                                                | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork                | host-project-id-nane2-standard-pbmm-main-snet                                                | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/vpc.yaml                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork                   | host-project-id-global-standard-vpc                                                          | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/org-policies/exceptions/compute-restrict-cloud-nat-usage-except-host-project.yaml | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy            | compute-restrict-cloud-nat-usage-except-host-project-id                                      | policies               |
| client-folder/standard/applications-infrastructure/host-project/project.yaml                                                                      | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project                          | host-project-id                                                                              | client-name-projects   |
| client-folder/standard/applications-infrastructure/host-project/project.yaml                                                                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeSharedVPCHostProject      | host-project-id-hostvpc                                                                      | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/services.yaml                                                                     | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                          | host-project-id-compute                                                                      | client-name-projects   |
| client-folder/standard/applications-infrastructure/host-project/services.yaml                                                                     | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                          | host-project-id-logging                                                                      | client-name-projects   |
| client-folder/standard/applications-infrastructure/host-project/services.yaml                                                                     | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                          | host-project-id-monitoring                                                                   | client-name-projects   |
| client-folder/standard/applications-infrastructure/host-project/services.yaml                                                                     | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                          | host-project-id-dns                                                                          | client-name-projects   |
| client-folder/standard/applications-infrastructure/host-project/services.yaml                                                                     | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                          | host-project-id-servicedirectory                                                             | client-name-projects   |
| client-folder/standard/applications-infrastructure/host-project/services.yaml                                                                     | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                          | host-project-id-container                                                                    | client-name-projects   |
| client-folder/standard/applications-infrastructure/nonp/folder.yaml                                                                               | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                           | standard.applications-infrastructure.nonp                                                    | client-name-hierarchy  |
| client-folder/standard/applications-infrastructure/pbmm/folder.yaml                                                                               | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                           | standard.applications-infrastructure.pbmm                                                    | client-name-hierarchy  |
| client-folder/standard/auto/folder.yaml                                                                                                           | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                           | standard.auto                                                                                | client-name-hierarchy  |
| client-folder/standard/auto/nonp/folder.yaml                                                                                                      | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                           | standard.auto.nonp                                                                           | client-name-hierarchy  |
| client-folder/standard/auto/pbmm/folder.yaml                                                                                                      | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                           | standard.auto.pbmm                                                                           | client-name-hierarchy  |
| client-folder/standard/firewall-policy/policy.yaml                                                                                                | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicy            | client-name-standard-fwpol                                                                   | client-name-networking |
| client-folder/standard/firewall-policy/policy.yaml                                                                                                | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyAssociation | client-name-standard-fwpol-association                                                       | client-name-networking |
| client-folder/standard/firewall-policy/rules/network-isolation.yaml                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-standard-fwpol-isolate-nonp-fwr                                                  | client-name-networking |
| client-folder/standard/firewall-policy/rules/network-isolation.yaml                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewallPolicyRule        | client-name-standard-fwpol-isolate-pbmm-fwr                                                  | client-name-networking |
| client-folder/standard/folder.yaml                                                                                                                | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                           | standard                                                                                     | client-name-hierarchy  |
| client-folder/standard/org-policies/exceptions/compute-restrict-load-balancer-creation-for-types.yaml                                             | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy            | compute-restrict-load-balancer-creation-for-types-except-client-name-standard-folder         | policies               |
| logging-project/cloud-logging-bucket.yaml                                                                                                         | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogBucket                 | platform-and-component-client-name-log-bucket                                                | logging                |
| logging-project/project-iam.yaml                                                                                                                  | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy                 | platform-and-component-log-client-name-bucket-writer-permissions                             | projects               |

## Resource References

- [ComputeAddress](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeaddress)
- [ComputeFirewallPolicyAssociation](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewallpolicyassociation)
- [ComputeFirewallPolicyRule](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewallpolicyrule)
- [ComputeFirewallPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewallpolicy)
- [ComputeFirewall](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewall)
- [ComputeForwardingRule](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeforwardingrule)
- [ComputeNetwork](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computenetwork)
- [ComputeRouterNAT](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computerouternat)
- [ComputeRouter](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computerouter)
- [ComputeSharedVPCHostProject](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computesharedvpchostproject)
- [ComputeSubnetwork](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computesubnetwork)
- [DNSManagedZone](https://cloud.google.com/config-connector/docs/reference/resource-docs/dns/dnsmanagedzone)
- [DNSPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/dns/dnspolicy)
- [DNSRecordSet](https://cloud.google.com/config-connector/docs/reference/resource-docs/dns/dnsrecordset)
- [Folder](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/folder)
- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [LoggingLogBucket](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogbucket)
- [LoggingLogSink](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogsink)
- [Project](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/project)
- [ResourceManagerPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/resourcemanagerpolicy)
- [Service](https://cloud.google.com/config-connector/docs/reference/resource-docs/serviceusage/service)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/client-landing-zone@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./client-landing-zone/"
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
