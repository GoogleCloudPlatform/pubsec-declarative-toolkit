<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# hub-env


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
A project that implements the Hub functionality from the Hub and Spoke network design.
This package is NOT required within an experimentation landing zone.

## Setters

|                 Name                  |                                                                                               Value                                                                                                | Type  | Count |
|---------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------|
| fgt-primary-image                     | projects/fortigcp-project-001/global/images/fortinet-fgtondemand-724-20230201-001-w-license                                                                                                        | str   |     1 |
| fgt-primary-license                   | LICENSE                                                                                                                                                                                            | str   |     1 |
|                                       |                                                                                                                                                                                                    |       |       |
| fgt-secondary-image                   | projects/fortigcp-project-001/global/images/fortinet-fgtondemand-724-20230201-001-w-license                                                                                                        | str   |     1 |
| fgt-secondary-license                 | LICENSE                                                                                                                                                                                            | str   |     1 |
| hub-admin                             | group:group@domain.com                                                                                                                                                                             | str   |     3 |
| hub-project-id                        | xxdmu-admin1-projectname                                                                                                                                                                           | str   |    94 |
| management-namespace                  | config-control                                                                                                                                                                                     | str   |     6 |
| management-project-id                 | management-project-id                                                                                                                                                                              | str   |     3 |
| org-id                                |                                                                                                                                                                                       123456789012 | str   |     3 |
| project-allowed-restrict-vpc-peering  | [under:organizations/ORGANIZATION_ID]                                                                                                                                                              | array |     1 |
| project-allowed-vm-can-ip-forward     | ["projects/PERIMETER_PROJECT_ID/zones/northamerica-northeast1-a/instances/fgt-primary-instance", "projects/PERIMETER_PROJECT_ID/zones/northamerica-northeast1-b/instances/fgt-secondary-instance"] | array |     0 |
| project-allowed-vm-external-ip-access | ["projects/PERIMETER_PROJECT_ID/zones/northamerica-northeast1-a/instances/fgt-primary-instance", "projects/PERIMETER_PROJECT_ID/zones/northamerica-northeast1-b/instances/fgt-secondary-instance"] | array |     2 |
| project-billing-id                    | AAAAAA-BBBBBB-CCCCCC                                                                                                                                                                               | str   |     1 |
| project-parent-folder                 | project-parent-folder                                                                                                                                                                              | str   |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|                                               File                                                |                  APIVersion                   |          Kind          |                                 Name                                 |   Namespace    |
|---------------------------------------------------------------------------------------------------|-----------------------------------------------|------------------------|----------------------------------------------------------------------|----------------|
| fortigate/address.yaml                                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | hub-fgt-primary-ext-address                                          | networking     |
| fortigate/address.yaml                                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | hub-fgt-secondary-ext-address                                        | networking     |
| fortigate/address.yaml                                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | hub-fgt-primary-int-address                                          | networking     |
| fortigate/address.yaml                                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | hub-fgt-secondary-int-address                                        | networking     |
| fortigate/address.yaml                                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | hub-fgt-primary-mgmt-address                                         | networking     |
| fortigate/address.yaml                                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | hub-fgt-secondary-mgmt-address                                       | networking     |
| fortigate/address.yaml                                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | hub-fgt-primary-transit-address                                      | networking     |
| fortigate/address.yaml                                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | hub-fgt-secondary-transit-address                                    | networking     |
| fortigate/address.yaml                                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | hub-ilb-address                                                      | networking     |
| fortigate/address.yaml                                                                            | compute.cnrm.cloud.google.com/v1beta1         | ComputeAddress         | hub-ilb-proxy-address                                                | networking     |
| fortigate/custom-role.yaml                                                                        | iam.cnrm.cloud.google.com/v1beta1             | IAMCustomRole          | hub-fortigatesdnreader-role                                          | config-control |
| fortigate/disk.yaml                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeDisk            | hub-fgt-primary-log-disk                                             | networking     |
| fortigate/disk.yaml                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeDisk            | hub-fgt-secondary-log-disk                                           | networking     |
| fortigate/elb.yaml                                                                                | compute.cnrm.cloud.google.com/v1beta1         | ComputeTargetPool      | hub-elb-pool                                                         | networking     |
| fortigate/elb.yaml                                                                                | compute.cnrm.cloud.google.com/v1beta1         | ComputeHTTPHealthCheck | hub-http-8008-httphc                                                 | networking     |
| fortigate/firewall.yaml                                                                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | hub-allow-external-fwr                                               | networking     |
| fortigate/firewall.yaml                                                                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | hub-elb-allow-health-checks-to-fortigate-fwr                         | networking     |
| fortigate/firewall.yaml                                                                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | hub-allow-spokes-to-fortigates-fwr                                   | networking     |
| fortigate/firewall.yaml                                                                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | hub-ilb-allow-health-checks-to-fortigate-fwr                         | networking     |
| fortigate/firewall.yaml                                                                           | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | hub-allow-fortigates-ha-fwr                                          | networking     |
| fortigate/fortigate-ap-primary.yaml                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeInstance        | hub-fgt-primary-instance                                             | networking     |
| fortigate/fortigate-ap-secondary.yaml                                                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeInstance        | hub-fgt-secondary-instance                                           | networking     |
| fortigate/ilb.yaml                                                                                | compute.cnrm.cloud.google.com/v1beta1         | ComputeHealthCheck     | hub-http-8008-hc                                                     | networking     |
| fortigate/ilb.yaml                                                                                | compute.cnrm.cloud.google.com/v1beta1         | ComputeBackendService  | hub-ilb-bes                                                          | networking     |
| fortigate/ilb.yaml                                                                                | compute.cnrm.cloud.google.com/v1beta1         | ComputeForwardingRule  | hub-ilb-fwdrule                                                      | networking     |
| fortigate/ilb.yaml                                                                                | compute.cnrm.cloud.google.com/v1beta1         | ComputeForwardingRule  | hub-ilb-proxy-fwdrule                                                | networking     |
| fortigate/management-vm/disk.yaml                                                                 | compute.cnrm.cloud.google.com/v1beta1         | ComputeDisk            | hub-mgmt-data-disk                                                   | networking     |
| fortigate/management-vm/firewall.yaml                                                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | hub-iap-allow-rdp-to-managementvm-fwr                                | networking     |
| fortigate/management-vm/firewall.yaml                                                             | compute.cnrm.cloud.google.com/v1beta1         | ComputeFirewall        | hub-managementvm-allow-ssh-https-to-fortigates-fwr                   | networking     |
| fortigate/management-vm/management-vm.yaml                                                        | compute.cnrm.cloud.google.com/v1beta1         | ComputeInstance        | hub-management-instance                                              | networking     |
| fortigate/management-vm/service-account.yaml                                                      | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | hub-managementvm-sa                                                  | networking     |
| fortigate/management-vm/service-account.yaml                                                      | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | hub-admin-serviceaccountuser-permissions                             | networking     |
| fortigate/route.yaml                                                                              | compute.cnrm.cloud.google.com/v1beta1         | ComputeRoute           | hub-internal-vpc-internet-egress-route                               | networking     |
| fortigate/service-account.yaml                                                                    | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | hub-fortigatesdn-sa                                                  | networking     |
| fortigate/service-account.yaml                                                                    | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | fortigatesdn-sa-fortigatesdnviewer-role-permissions                  | config-control |
| fortigate/umig.yaml                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeInstanceGroup   | hub-fgt-primary-umig                                                 | networking     |
| fortigate/umig.yaml                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeInstanceGroup   | hub-fgt-secondary-umig                                               | networking     |
| network/dns.yaml                                                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy              | hub-external-logging-dnspolicy                                       | networking     |
| network/dns.yaml                                                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy              | hub-internal-logging-dnspolicy                                       | networking     |
| network/dns.yaml                                                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy              | hub-mgmt-logging-dnspolicy                                           | networking     |
| network/dns.yaml                                                                                  | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy              | hub-transit-logging-dnspolicy                                        | networking     |
| network/nat.yaml                                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouterNAT       | hub-nane1-external-nat                                               | networking     |
| network/nat.yaml                                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouter          | hub-nane1-external-router                                            | networking     |
| network/route.yaml                                                                                | compute.cnrm.cloud.google.com/v1beta1         | ComputeRoute           | hub-external-vpc-internet-egress-route                               | networking     |
| network/subnet.yaml                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork      | hub-nane1-external-paz-snet                                          | networking     |
| network/subnet.yaml                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork      | hub-nane1-internal-paz-snet                                          | networking     |
| network/subnet.yaml                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork      | hub-nane1-mgmt-rz-snet                                               | networking     |
| network/subnet.yaml                                                                               | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork      | hub-nane1-transit-paz-snet                                           | networking     |
| network/vpc.yaml                                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork         | hub-global-external-vpc                                              | networking     |
| network/vpc.yaml                                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork         | hub-global-internal-vpc                                              | networking     |
| network/vpc.yaml                                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork         | hub-global-mgmt-vpc                                                  | networking     |
| network/vpc.yaml                                                                                  | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork         | hub-global-transit-vpc                                               | networking     |
| org-policies/exceptions/compute-disable-serial-port-access-except-hub-project.yaml                | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-disable-serial-port-access-except-hub-project                | policies       |
| org-policies/exceptions/compute-require-shielded-vm-except-hub-project.yaml                       | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-require-shielded-vm-except-hub-project                       | policies       |
| org-policies/exceptions/compute-restrict-load-balancer-creation-for-types-except-hub-project.yaml | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-restrict-load-balancer-creation-for-types-except-hub-project | policies       |
| org-policies/exceptions/compute-restrict-vpc-peering-except-hub-project.yaml                      | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-restrict-vpc-peering-except-hub-project                      | policies       |
| org-policies/exceptions/compute-trusted-image-projects-except-hub-project.yaml                    | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-trusted-image-projects-except-hub-project                    | policies       |
| org-policies/exceptions/compute-vm-can-ip-forward-except-hub-project.yaml                         | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-vm-can-ip-forward-except-hub-project                         | policies       |
| org-policies/exceptions/compute-vm-external-ip-access-except-hub-project.yaml                     | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy  | compute-vm-external-ip-access-except-hub-project                     | policies       |
| project-iam.yaml                                                                                  | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-serviceaccountadmin-permissions                        | config-control |
| project-iam.yaml                                                                                  | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-serviceaccountuser-permissions                         | config-control |
| project-iam.yaml                                                                                  | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | networking-sa-computeinstanceadmin-permissions                       | config-control |
| project-iam.yaml                                                                                  | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | hub-admin-iaptunnelresourceaccessor-permissions                      | config-control |
| project-iam.yaml                                                                                  | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | hub-admin-computeinstanceadmin-permissions                           | config-control |
| project.yaml                                                                                      | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project                | hub-project-id                                                       | projects       |
| services.yaml                                                                                     | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | hub-project-id-compute                                               | projects       |
| services.yaml                                                                                     | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | hub-project-id-dns                                                   | projects       |

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
- [ResourceManagerPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/resourcemanagerpolicy)
- [Service](https://cloud.google.com/config-connector/docs/reference/resource-docs/serviceusage/service)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/project/hub-env@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./hub-env/"
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