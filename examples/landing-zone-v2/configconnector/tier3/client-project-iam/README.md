<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# client-project-iam


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->


<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Depends on `client-project-setup` package and tier3 namespace.

**Example** to manage users and tier4 service account roles.

Edit roles based on the project's requirements and deploy once per service project in the tier3 namespace.

## Setters

|    Name     |          Value          | Type | Count |
|-------------|-------------------------|------|-------|
| project-id  | client-project-12345    | str  |     5 |
| users-group | group:users@example.com | str  |     7 |

## Sub-packages

This package has no sub-packages.

## Resources

|       File        |            APIVersion             |       Kind       |              Name               | Namespace |
|-------------------|-----------------------------------|------------------|---------------------------------|-----------|
| iam-tier4-sa.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPartialPolicy | project-id-tier4-sa-permissions |           |
| iam-users.yaml    | iam.cnrm.cloud.google.com/v1beta1 | IAMPartialPolicy | project-id-users-permissions    |           |

## Resource References

- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/examples/landing-zone-v2/configconnector/tier3/client-project-iam@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./client-project-iam/"
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
