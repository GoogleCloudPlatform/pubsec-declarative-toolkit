<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# client-landing-zone


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Depends on `client-setup`.

Package to create a client's folder hierarchy, logging resources and a network host project.

## Setters

|                Name                |                    Value                    | Type  | Count |
|------------------------------------|---------------------------------------------|-------|-------|
| client-billing-id                  | AAAAAA-BBBBBB-CCCCCC                        | str   |     1 |
| client-folderviewer                | group:client1@example.com                   | str   |     1 |
| client-name                        | client1                                     | str   |    74 |
| firewall-egress-allow-all-internal | [10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16] | array |     1 |
| host-project-id                    | net-host-project-12345                      | str   |    95 |
| logging-project-id                 | logging-project-12345                       | str   |     2 |
| retention-in-days                  |                                           1 | int   |     1 |
| retention-locking-policy           | false                                       | bool  |     1 |
| standard-nane1-protected-a-snet    | 10.1.64.0/21                                | str   |     1 |
| standard-nane1-protected-b-snet    | 10.1.128.0/21                               | str   |     1 |
| standard-nane1-unclassified-snet   | 10.1.0.0/21                                 | str   |     1 |
| standard-nane2-protected-a-snet    | 10.1.72.0/21                                | str   |     1 |
| standard-nane2-protected-b-snet    | 10.1.136.0/21                               | str   |     1 |
| standard-nane2-unclassified-snet   | 10.1.8.0/21                                 | str   |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|                                                                  File                                                                   |                  APIVersion                   |            Kind             |                               Name                               |       Namespace        |
|-----------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|-----------------------------|------------------------------------------------------------------|------------------------|
| client-folder/folder-iam.yaml                                                                                                           | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember             | clients.client-name-client-folder-viewer-permissions             | client-name-hierarchy  |
| client-folder/folder-sink.yaml                                                                                                          | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink              | platform-and-component-log-client-name-log-sink                  | logging                |
| client-folder/standard/applications/folder.yaml                                                                                         | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                      | standard.applications                                            | client-name-hierarchy  |
| client-folder/standard/applications/nonp/folder.yaml                                                                                    | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                      | standard.applications.nonp                                       | client-name-hierarchy  |
| client-folder/standard/applications/pbmm/folder.yaml                                                                                    | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                      | standard.applications.pbmm                                       | client-name-hierarchy  |
| client-folder/standard/applications-infrastructure/folder.yaml                                                                          | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                      | standard.applications-infrastructure                             | client-name-hierarchy  |
| client-folder/standard/applications-infrastructure/host-project/network/dnspolicy.yaml                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy                   | host-project-id-standard-logging-dnspolicy                       | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml                                                   | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall             | host-project-id-standard-egress-allow-all-internal-fwr           | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml                                                   | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall             | host-project-id-standard-default-egress-deny-fwr                 | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                        | dns.cnrm.cloud.google.com/v1beta1             | DNSManagedZone              | host-project-id-standard-googleapis-dns                          | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                        | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                | host-project-id-standard-googleapis-rset                         | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                        | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                | host-project-id-standard-googleapis-wildcard-rset                | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                        | dns.cnrm.cloud.google.com/v1beta1             | DNSManagedZone              | host-project-id-standard-gcrio-dns                               | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                        | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                | host-project-id-standard-gcrio-rset                              | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml                                        | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                | host-project-id-standard-gcrio-wildcard-rset                     | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/firewall.yaml                                   | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall             | host-project-id-standard-egress-allow-psc-fwr                    | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/psc.yaml                                        | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress              | host-project-id-standard-psc-apis-ip                             | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/psc.yaml                                        | compute.cnrm.cloud.google.com/v1beta1         | ComputeForwardingRule       | host-project-id-standard-psc-apis-fw                             | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml                                                     | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | host-project-id-nane1-standard-unclassified-snet                 | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml                                                     | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | host-project-id-nane1-standard-protected-a-snet                  | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml                                                     | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | host-project-id-nane1-standard-protected-b-snet                  | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml                                                     | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | host-project-id-nane2-standard-unclassified-snet                 | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml                                                     | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | host-project-id-nane2-standard-protected-a-snet                  | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml                                                     | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | host-project-id-nane2-standard-protected-b-snet                  | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/network/vpc.yaml                                                        | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork              | host-project-id-global-standard-vpc                              | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/org-policies/exceptions/gcp-resource-locations-except-host-project.yaml | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy       | gcp-restrict-resource-locations-except-host-project-id           | policies               |
| client-folder/standard/applications-infrastructure/host-project/project.yaml                                                            | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project                     | host-project-id                                                  | client-name-projects   |
| client-folder/standard/applications-infrastructure/host-project/project.yaml                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeSharedVPCHostProject | host-project-id-hostvpc                                          | client-name-networking |
| client-folder/standard/applications-infrastructure/host-project/services.yaml                                                           | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                     | host-project-id-compute                                          | client-name-projects   |
| client-folder/standard/applications-infrastructure/host-project/services.yaml                                                           | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                     | host-project-id-dns                                              | client-name-projects   |
| client-folder/standard/applications-infrastructure/host-project/services.yaml                                                           | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                     | host-project-id-servicedirectory                                 | client-name-projects   |
| client-folder/standard/applications-infrastructure/host-project/services.yaml                                                           | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                     | host-project-id-container                                        | client-name-projects   |
| client-folder/standard/applications-infrastructure/nonp/folder.yaml                                                                     | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                      | standard.applications-infrastructure.nonp                        | client-name-hierarchy  |
| client-folder/standard/applications-infrastructure/pbmm/folder.yaml                                                                     | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                      | standard.applications-infrastructure.pbmm                        | client-name-hierarchy  |
| client-folder/standard/auto/folder.yaml                                                                                                 | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                      | standard.auto                                                    | client-name-hierarchy  |
| client-folder/standard/auto/nonp/folder.yaml                                                                                            | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                      | standard.auto.nonp                                               | client-name-hierarchy  |
| client-folder/standard/auto/pbmm/folder.yaml                                                                                            | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                      | standard.auto.pbmm                                               | client-name-hierarchy  |
| client-folder/standard/folder.yaml                                                                                                      | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                      | standard                                                         | client-name-hierarchy  |
| logging-project/cloud-logging-bucket.yaml                                                                                               | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogBucket            | platform-and-component-client-name-log-bucket                    | logging                |
| logging-project/project-iam.yaml                                                                                                        | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy            | platform-and-component-log-client-name-bucket-writer-permissions | projects               |

## Resource References

- [ComputeAddress](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeaddress)
- [ComputeFirewall](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewall)
- [ComputeForwardingRule](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeforwardingrule)
- [ComputeNetwork](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computenetwork)
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
    cd ".//solutions/client-landing-zone/"
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
