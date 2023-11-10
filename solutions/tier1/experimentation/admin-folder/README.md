<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# admin-folder


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing Zone v2 experimentation subpackage.
Depends on core-landing-zone

Creates an admin folder underneath tests.admins
This package should only be deployed within a experimentation landing zone.

## Setters

|    Name     |          Value          | Type | Count |
|-------------|-------------------------|------|-------|
| admin-name  | admin1                  | str  |     8 |
| admin-owner | user:admin1@example.com | str  |     3 |

## Sub-packages

This package has no sub-packages.

## Resources

|      File       |                  APIVersion                   |      Kind       |                      Name                       | Namespace |
|-----------------|-----------------------------------------------|-----------------|-------------------------------------------------|-----------|
| folder-iam.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember | admins.admin1-admin-folder-admin-permissions    | hierarchy |
| folder-iam.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember | admins.admin1-admin-project-creator-permissions | hierarchy |
| folder-iam.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember | admins.admin1-admin-owner-permissions           | hierarchy |
| folder.yaml     | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder          | tests.admins.admin1                             | hierarchy |

## Resource References

- [Folder](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/folder)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/experimentation/admin-folder@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./admin-folder/"
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
