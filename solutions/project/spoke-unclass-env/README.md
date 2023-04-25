<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# spoke-unclass-env


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
A shared vpc project that implements the Spoke for unclassified data from the Hub and Spoke network design.
This package is NOT required within an experimentation landing zone.

## Setters

|               Name               |                                     Value                                      | Type  | Count |
|----------------------------------|--------------------------------------------------------------------------------|-------|-------|
| firewall-default-egress-deny-all | [10.1.1.0/24, 10.1.2.0/24, 10.1.3.0/24, 10.2.1.0/24, 10.2.2.0/24, 10.2.3.0/24] | array |     1 |
| nane1-apprz-snet                 | 10.1.2.0/24                                                                    | str   |     1 |
| nane1-datarz-snet                | 10.1.3.0/24                                                                    | str   |     1 |
| nane1-paz-snet                   | 10.1.1.0/24                                                                    | str   |     1 |
| nane2-apprz-snet                 | 10.2.2.0/24                                                                    | str   |     1 |
| nane2-datarz-snet                | 10.2.3.0/24                                                                    | str   |     1 |
| nane2-paz-snet                   | 10.2.1.0/24                                                                    | str   |     1 |
| project-billing-id               | AAAAAA-BBBBBB-CCCCCC                                                           | str   |     1 |
| project-id                       | xxdmu-admin1-projectname                                                       | str   |    95 |
| project-parent-folder            | project-parent-folder                                                          | str   |     2 |

## Sub-packages

This package has no sub-packages.

## Resources

|                                   File                                   |                  APIVersion                   |            Kind             |                       Name                        | Namespace  |
|--------------------------------------------------------------------------|-----------------------------------------------|-----------------------------|---------------------------------------------------|------------|
| network/dnspolicy.yaml                                                   | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy                   | project-id-logging-dnspolicy                      | networking |
| network/peering.yaml                                                     | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetworkPeering       | project-id-to-hub-peer                            | networking |
| network/peering.yaml                                                     | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetworkPeering       | hub-to-project-id-peer                            | networking |
| network/psc/google-apis/dns.yaml                                         | dns.cnrm.cloud.google.com/v1beta1             | DNSManagedZone              | project-id-googleapis-dns                         | networking |
| network/psc/google-apis/dns.yaml                                         | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                | project-id-googleapis-rset                        | networking |
| network/psc/google-apis/dns.yaml                                         | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                | project-id-googleapis-wildcard-rset               | networking |
| network/psc/google-apis/dns.yaml                                         | dns.cnrm.cloud.google.com/v1beta1             | DNSManagedZone              | project-id-gcrio-dns                              | networking |
| network/psc/google-apis/dns.yaml                                         | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                | project-id-gcrio-rset                             | networking |
| network/psc/google-apis/dns.yaml                                         | dns.cnrm.cloud.google.com/v1beta1             | DNSRecordSet                | project-id-gcrio-wildcard-rset                    | networking |
| network/psc/google-apis/firewall.yaml                                    | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall             | project-id-egress-allow-psc-fwr                   | networking |
| network/psc/google-apis/firewall.yaml                                    | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall             | project-id-default-egress-deny-fwr                | networking |
| network/psc/google-apis/psc.yaml                                         | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress              | project-id-psc-apis-ip                            | networking |
| network/psc/google-apis/psc.yaml                                         | compute.cnrm.cloud.google.com/v1beta1         | ComputeForwardingRule       | project-id-psc-apis-fw                            | networking |
| network/subnet.yaml                                                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | project-id-nane1-vpc1-paz-snet                    | networking |
| network/subnet.yaml                                                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | project-id-nane1-vpc1-apprz-snet                  | networking |
| network/subnet.yaml                                                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | project-id-nane1-vpc1-datarz-snet                 | networking |
| network/subnet.yaml                                                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | project-id-nane2-vpc1-paz-snet                    | networking |
| network/subnet.yaml                                                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | project-id-nane2-vpc1-apprz-snet                  | networking |
| network/subnet.yaml                                                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork           | project-id-nane2-vpc1-datarz-snet                 | networking |
| network/vpc.yaml                                                         | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork              | project-id-global-vpc1-vpc                        | networking |
| org-policies/exceptions/gcp-resource-locations-except-spoke-project.yaml | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy       | gcp-restrict-resource-locations-except-project-id | policies   |
| project.yaml                                                             | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project                     | project-id                                        | projects   |
| project.yaml                                                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeSharedVPCHostProject | project-id-hostvpc                                | networking |
| services.yaml                                                            | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                     | project-id-compute                                | projects   |
| services.yaml                                                            | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                     | project-id-dns                                    | projects   |
| services.yaml                                                            | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                     | project-id-servicedirectory                       | projects   |

## Resource References

- [ComputeAddress](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeaddress)
- [ComputeFirewall](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewall)
- [ComputeForwardingRule](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeforwardingrule)
- [ComputeNetworkPeering](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computenetworkpeering)
- [ComputeNetwork](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computenetwork)
- [ComputeSharedVPCHostProject](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computesharedvpchostproject)
- [ComputeSubnetwork](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computesubnetwork)
- [DNSManagedZone](https://cloud.google.com/config-connector/docs/reference/resource-docs/dns/dnsmanagedzone)
- [DNSPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/dns/dnspolicy)
- [DNSRecordSet](https://cloud.google.com/config-connector/docs/reference/resource-docs/dns/dnsrecordset)
- [Project](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/project)
- [ResourceManagerPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/resourcemanagerpolicy)
- [Service](https://cloud.google.com/config-connector/docs/reference/resource-docs/serviceusage/service)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/project/spoke-unclass-envspoke-unclass-env@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./spoke-unclass-env/"
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