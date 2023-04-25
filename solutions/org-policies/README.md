<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# org-policies


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
A package to create GCP Organization Policies.
Attention, validate impact with CCCS Cloud Based Sensors before implementing any changes.

## Setters

|              Name              |                  Value                  | Type  | Count |
|--------------------------------|-----------------------------------------|-------|-------|
| allowed-contact-domains        | ["@example.com"]                        | array |     1 |
| allowed-load-balancer-types    | [INTERNAL_HTTP_HTTPS, INTERNAL_TCP_UDP] | array |     1 |
| allowed-policy-domain-members  | ["DIRECTORY_CUSTOMER_ID"]               | array |     1 |
| allowed-trusted-image-projects | ["projects/cos-cloud"]                  | array |     1 |
| allowed-vpc-peering            | ["under:organizations/ORGANIZATION_ID"] | array |     1 |
| lz-folder-id                   |                              0000000000 | str   |     0 |
| management-project-id          | management-project-12345                | str   |     1 |
| org-id                         |                              0000000000 | str   |    20 |

## Sub-packages

This package has no sub-packages.

## Resources

|                                File                                 |                  APIVersion                   |         Kind          |                       Name                        | Namespace |
|---------------------------------------------------------------------|-----------------------------------------------|-----------------------|---------------------------------------------------|-----------|
| exceptions/compute-require-shielded-vm-except-mgt-project.yaml      | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-require-shielded-vm-except-mgt-project    | policies  |
| organization/compute-disable-guest-attribute-access.yaml            | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-disable-guest-attribute-access            | policies  |
| organization/compute-disable-nested-virtualization.yaml             | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-disable-nested-virtualization             | policies  |
| organization/compute-disable-serial-port-access.yaml                | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-disable-serial-port-access                | policies  |
| organization/compute-disable-vpc-external-ipv6.yaml                 | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-disable-vpc-external-ipv6                 | policies  |
| organization/compute-require-os-login.yaml                          | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-require-os-login                          | policies  |
| organization/compute-require-shielded-vm.yaml                       | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-require-shielded-vm                       | policies  |
| organization/compute-restrict-load-balancer-creation-for-types.yaml | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-restrict-load-balancer-creation-for-types | policies  |
| organization/compute-restrict-shared-vpc-lien-removal.yaml          | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-restrict-shared-vpc-lien-removal          | policies  |
| organization/compute-restrict-vpc-peering.yaml                      | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-restrict-vpc-peering                      | policies  |
| organization/compute-skip-default-network-creation.yaml             | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-skip-default-network-creation             | policies  |
| organization/compute-trusted-image-projects.yaml                    | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-trusted-image-projects                    | policies  |
| organization/compute-vm-can-ip-forward.yaml                         | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-vm-can-ip-forward                         | policies  |
| organization/compute-vm-external-ip-access.yaml                     | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | compute-vm-external-ip-access                     | policies  |
| organization/essentialcontacts-allowed-contact-domains.yaml         | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | essentialcontacts-allowed-contact-domains         | policies  |
| organization/gcp-resource-locations.yaml                            | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | gcp-restrict-resource-locations                   | policies  |
| organization/iam-allowed-policy-member-domains.yaml                 | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | iam-allowed-policy-member-domains                 | policies  |
| organization/iam-disable-service-account-key-creation.yaml          | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | iam-disable-service-account-key-creation          | policies  |
| organization/sql-restrict-public-ip.yaml                            | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | sql-restrict-public-ip                            | policies  |
| organization/storage-public-access-prevention.yaml                  | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | storage-public-access-prevention                  | policies  |
| organization/storage-uniform-bucket-level-access.yaml               | resourcemanager.cnrm.cloud.google.com/v1beta1 | ResourceManagerPolicy | storage-uniform-bucket-level-access               | policies  |

## Resource References

- [ResourceManagerPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/resourcemanagerpolicy)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/org-policies/org-policies@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./org-policies/"
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

## Additional information

The `organization` folder contains a file for each policy to be applied.

The `exceptions` folder can be used to manage exceptions at the folder and/or project level.

## Requirements

- A management project with KCC installed.
- The `landing-zone` package containing the `policies` namespace and associated resources.