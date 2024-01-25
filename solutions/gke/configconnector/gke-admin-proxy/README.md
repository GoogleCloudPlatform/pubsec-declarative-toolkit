<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# gke-admin-proxy


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->



<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 optional package to deploy a compute engine instance in a given project for managing a private GKE cluster.

Depends on `client-setup`, uses the client namespaces.

Refer to the [documentation](https://cloud.google.com/kubernetes-engine/docs/tutorials/private-cluster-bastion) for more details.

## Setters

|             Name             |                  Value                  | Type  | Count |
|------------------------------|-----------------------------------------|-------|-------|
| client-management-project-id | client-management-project-12345         | str   |     3 |
| client-name                  | client1                                 | str   |    35 |
| gke-admins                   | [member: 'group:my-admins@example.com'] | array |     4 |
| host-project-id              | host-project-id                         | str   |     2 |
| instance-ip                  | instance-ip                             | str   |     1 |
| instance-machine-type        | instance-machine-type                   | str   |     1 |
| instance-name                | instance-name                           | str   |    21 |
| instance-os-image            | instance-os-image                       | str   |     1 |
| location                     | location                                | str   |     2 |
| network-name                 | network-name                            | str   |     2 |
| project-id                   | project-id-12345                        | str   |    35 |
| subnet-name                  | subnet-name                             | str   |     2 |

## Sub-packages

- [instance-resources](instance-resources)

## Resources

|       File       |            APIVersion             |       Kind       |                                Name                                |      Namespace       |
|------------------|-----------------------------------|------------------|--------------------------------------------------------------------|----------------------|
| project-iam.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPolicyMember  | project-id-client-name-admin-sa-service-account-admin-permissions  | client-name-projects |
| project-iam.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPolicyMember  | project-id-client-name-admin-sa-compute-instance-admin-permissions | client-name-projects |
| project-iam.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPolicyMember  | project-id-client-name-admin-sa-service-account-user-permissions   | client-name-projects |
| project-iam.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPartialPolicy | project-id-gke-admins-permissions                                  | client-name-projects |

## Resource References

- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gke/configconnector/gke-admin-proxy@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./gke-admin-proxy/"
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
