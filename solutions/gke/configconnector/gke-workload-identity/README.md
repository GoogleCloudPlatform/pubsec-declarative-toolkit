<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# gke-workload-identity


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Depends on package `gke-defaults`.
Requires project-id-tier3 namespace.

Deploy this package once per application namespace.

A package to deploy Google Service Account and grant it secretmanager.secretAccessor role within the GKE project. It binds it to Kubernetes Service Account using workload identity.

## Setters

|     Name      |      Value      | Type | Count |
|---------------|-----------------|------|-------|
| client-name   | client1         | str  |     1 |
| project-id    | project-12345   | str  |     7 |
| workload-name | sample-workload | str  |     7 |

## Sub-packages

This package has no sub-packages.

## Resources

|          File          |            APIVersion             |       Kind        |                           Name                            |    Namespace     |
|------------------------|-----------------------------------|-------------------|-----------------------------------------------------------|------------------|
| workload-identity.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMServiceAccount | workload-name-sa                                          | project-id-tier3 |
| workload-identity.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPolicyMember   | workload-name-sa-secretmanager-secretaccessor-permissions | project-id-tier3 |
| workload-identity.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPartialPolicy  | workload-name-sa-secretaccessor-permissions               | project-id-tier3 |

## Resource References

- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [IAMServiceAccount](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamserviceaccount)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gke/configconnector/gke-workload-identity@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./gke-workload-identity/"
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
