<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# Perimeter


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
A perimeter project that implements the Hub from the Hub and Spoke network design. 
This package is NOT required within an experimentation landing zone.

## Setters

|         Name          |                                            Value                                            | Type | Count |
|-----------------------|---------------------------------------------------------------------------------------------|------|-------|
| fgt-primary-image     | projects/fortigcp-project-001/global/images/fortinet-fgtondemand-722-20221004-001-w-license | str  |     1 |
| fgt-primary-license   |                                                                                             | str  |     1 |
| fgt-secondary-image   | projects/fortigcp-project-001/global/images/fortinet-fgtondemand-722-20221004-001-w-license | str  |     1 |
| fgt-secondary-license |                                                                                             | str  |     1 |
| management-namespace  | config-control                                                                              | str  |     4 |
| management-project-id | management-project-id                                                                       | str  |     3 |
| org-id                |                                                                                123456789012 | str  |     3 |
| perimeter-project-id  | xxdmu-admin1-projectname                                                                    | str  |    67 |
| project-billing-id    | AAAAAA-BBBBBB-CCCCCC                                                                        | str  |     1 |
| project-parent-folder | project-parent-folder                                                                       | str  |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|                     File                     |                  APIVersion                   |          Kind          |                           Name                           |   Namespace    |
|----------------------------------------------|-----------------------------------------------|------------------------|----------------------------------------------------------|----------------|
| fortigate/address.yaml                       | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | perimeter-fgt-primary-ext-address                        | networking     |
| fortigate/address.yaml                       | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | perimeter-fgt-secondary-ext-address                      | networking     |
| fortigate/address.yaml                       | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | perimeter-fgt-primary-int-address                        | networking     |
| fortigate/address.yaml                       | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | perimeter-fgt-secondary-int-address                      | networking     |
| fortigate/address.yaml                       | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | perimeter-fgt-primary-mgmt-address                       | networking     |
| fortigate/address.yaml                       | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | perimeter-fgt-secondary-mgmt-address                     | networking     |
| fortigate/address.yaml                       | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | perimeter-fgt-primary-transit-address                    | networking     |
| fortigate/address.yaml                       | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | perimeter-fgt-secondary-transit-address                  | networking     |
| fortigate/address.yaml                       | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | perimeter-ilb-address                                    | networking     |
| fortigate/address.yaml                       | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | perimeter-ilb-proxy-address                              | networking     |
| fortigate/custom-role.yaml                   | iam.cnrm.cloud.google.com/v1beta1             | IAMCustomRole          | perimeter-fortigatesdnreader-role                        | config-control |
| fortigate/disk.yaml                          | compute.cnrm.cloud.google.com/v1beta1         | ComputeDisk            | perimeter-fgt-primary-log-disk                           | networking     |
| fortigate/disk.yaml                          | compute.cnrm.cloud.google.com/v1beta1         | ComputeDisk            | perimeter-fgt-secondary-log-disk                         | networking     |
| fortigate/elb.yaml                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeTargetPool      | perimeter-elb-pool                                       | networking     |
| fortigate/elb.yaml                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeHTTPHealthCheck | perimeter-http-8008-httphc                               | networking     |
| fortigate/firewall.yaml                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | perimeter-allow-external-fwr                             | networking     |
| fortigate/firewall.yaml                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | perimeter-elb-allow-health-checks-to-fortigate-fwr       | networking     |
| fortigate/firewall.yaml                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | perimeter-allow-spokes-to-fortigates-fwr                 | networking     |
| fortigate/firewall.yaml                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | perimeter-ilb-allow-health-checks-to-fortigate-fwr       | networking     |
| fortigate/firewall.yaml                      | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | perimeter-allow-fortigates-ha-fwr                        | networking     |
| fortigate/fortigate-ap-primary.yaml          | compute.cnrm.cloud.google.com/v1beta1         | ComputeInstance        | perimeter-fgt-primary-instance                           | networking     |
| fortigate/fortigate-ap-secondary.yaml        | compute.cnrm.cloud.google.com/v1beta1         | ComputeInstance        | perimeter-fgt-secondary-instance                         | networking     |
| fortigate/ilb.yaml                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeHealthCheck     | perimeter-http-8008-hc                                   | networking     |
| fortigate/ilb.yaml                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeBackendService  | perimeter-ilb-bes                                        | networking     |
| fortigate/ilb.yaml                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeForwardingRule  | perimeter-ilb-fwdrule                                    | networking     |
| fortigate/ilb.yaml                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeForwardingRule  | perimeter-ilb-proxy-fwdrule                              | networking     |
| fortigate/management-vm/disk.yaml            | compute.cnrm.cloud.google.com/v1beta1         | ComputeDisk            | perimeter-mgmt-data-disk                                 | networking     |
| fortigate/management-vm/firewall.yaml        | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | perimeter-iap-allow-rdp-to-managementvm-fwr              | networking     |
| fortigate/management-vm/firewall.yaml        | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | perimeter-managementvm-allow-ssh-https-to-fortigates-fwr | networking     |
| fortigate/management-vm/management-vm.yaml   | compute.cnrm.cloud.google.com/v1beta1         | ComputeInstance        | perimeter-management-instance                            | networking     |
| fortigate/management-vm/service-account.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | perimeter-managementvm-sa                                | networking     |
| fortigate/route.yaml                         | compute.cnrm.cloud.google.com/v1beta1         | ComputeRoute           | perimeter-internal-vpc-internet-egress-route             | networking     |
| fortigate/service-account.yaml               | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | perimeter-fortigatesdn-sa                                | networking     |
| fortigate/service-account.yaml               | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | fortigatesdn-sa-fortigatesdnviewer-role-permissions      | config-control |
| fortigate/umig.yaml                          | compute.cnrm.cloud.google.com/v1beta1         | ComputeInstanceGroup   | perimeter-fgt-primary-umig                               | networking     |
| fortigate/umig.yaml                          | compute.cnrm.cloud.google.com/v1beta1         | ComputeInstanceGroup   | perimeter-fgt-secondary-umig                             | networking     |
| network/dns.yaml                             | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy              | perimeter-external-logging-dnspolicy                     | networking     |
| network/dns.yaml                             | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy              | perimeter-internal-logging-dnspolicy                     | networking     |
| network/dns.yaml                             | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy              | perimeter-mgmt-logging-dnspolicy                         | networking     |
| network/dns.yaml                             | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy              | perimeter-transit-logging-dnspolicy                      | networking     |
| network/nat.yaml                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouterNAT       | perimeter-nane1-external-nat                             | networking     |
| network/nat.yaml                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouter          | perimeter-nane1-external-router                          | networking     |
| network/route.yaml                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeRoute           | perimeter-external-vpc-internet-egress-route             | networking     |
| network/subnet.yaml                          | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork      | perimeter-nane1-external-paz-snet                        | networking     |
| network/subnet.yaml                          | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork      | perimeter-nane1-internal-paz-snet                        | networking     |
| network/subnet.yaml                          | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork      | perimeter-nane1-mgmt-rz-snet                             | networking     |
| network/subnet.yaml                          | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork      | perimeter-nane1-transit-paz-snet                         | networking     |
| network/vpc.yaml                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork         | perimeter-global-external-vpc                            | networking     |
| network/vpc.yaml                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork         | perimeter-global-internal-vpc                            | networking     |
| network/vpc.yaml                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork         | perimeter-global-mgmt-vpc                                | networking     |
| network/vpc.yaml                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork         | perimeter-global-transit-vpc                             | networking     |
| project-iam.yaml                             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-serviceaccountadmin-permissions            | config-control |
| project-iam.yaml                             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-serviceaccountuser-permissions             | config-control |
| project-iam.yaml                             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-computeinstanceadmin-permissions           | config-control |
| project.yaml                                 | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project                | perimeter-project-id                                     | projects       |
| services.yaml                                | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | perimeter-project-id-compute                             | projects       |
| services.yaml                                | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | perimeter-project-id-dns                                 | projects       |

## Resource References

- [ComputeAddress](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeaddress)
- [ComputeBackendService](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computebackendservice)
- [ComputeDisk](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computedisk)
- [ComputeFirewall](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewall)
- [ComputeForwardingRule](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeforwardingrule)
- [ComputeHTTPHealthCheck](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computehttphealthcheck)
- [ComputeHealthCheck](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computehealthcheck)
- [ComputeInstanceGroup](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeinstancegroup)
- [ComputeInstance](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeinstance)
- [ComputeNetwork](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computenetwork)
- [ComputeRoute](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeroute)
- [ComputeRouterNAT](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computerouternat)
- [ComputeRouter](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computerouter)
- [ComputeSubnetwork](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computesubnetwork)
- [ComputeTargetPool](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computetargetpool)
- [DNSPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/dns/dnspolicy)
- [IAMCustomRole](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamcustomrole)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [IAMServiceAccount](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamserviceaccount)
- [Project](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/project)
- [Service](https://cloud.google.com/config-connector/docs/reference/resource-docs/serviceusage/service)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/perimeter@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./perimeter/"
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