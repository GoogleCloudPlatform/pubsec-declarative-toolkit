<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# gateway-setup


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
gke subpackage.
Requires project-id-tier3 namespace.

Deploy this package once per gateway resources. You can have multiple copies of this subpackage by cloning the entire folder to a new folder (i.e. subpackage2)

This package deploys the resources that are required by a kubernetes gateway (Gateway Controller).

## Setters

|       Name       |      Value       | Type  | Count |
|------------------|------------------|-------|-------|
| certificate-id   |         12345678 | int   |     1 |
| certificate-name | certificate-name | str   |     3 |
| client-name      | client-name      | str   |     2 |
| dns-project-id   | dns-project-id   | str   |     1 |
| domains          | [example.com]    | array |     1 |
| gateway-name     | sample-gateway   | str   |     3 |
| metadata-name    | metadata-name    | str   |     1 |
| project-id       | project-12345    | str   |     6 |
| spec-name        | dns-name         | str   |     1 |

## Sub-packages

- [dns](dns)
- [ssl-certificate](ssl-certificate)

## Resources

|  File   |              APIVersion               |      Kind      |             Name             |    Namespace     |
|---------|---------------------------------------|----------------|------------------------------|------------------|
| ip.yaml | compute.cnrm.cloud.google.com/v1beta1 | ComputeAddress | gateway-name-compute-address | project-id-tier3 |

## Resource References

- [ComputeAddress](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeaddress)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gke/configconnector/gke-defaults/gateway-setup@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./gateway-setup/"
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
