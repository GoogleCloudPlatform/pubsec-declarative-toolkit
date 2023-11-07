<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# ssl-certificate


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
gateway-setup subpackage.
Requires project-id-tier3 namespace.

Deploy this package once per certificate. You can have multiple copies of this subpackage by cloning the entire folder to a new folder (i.e. subpackage2)

A package to deploy a google managed classic certificate.

## Setters

|       Name       |           Value           | Type  | Count |
|------------------|---------------------------|-------|-------|
| certificate-name | sample-name               | str   |     3 |
| domains          | [sample-name.example.com] | array |     1 |
| project-id       | project-12345             | str   |     2 |

## Sub-packages

This package has no sub-packages.

## Resources

|   File   |               APIVersion               |             Kind             |                  Name                   |    Namespace     |
|----------|----------------------------------------|------------------------------|-----------------------------------------|------------------|
| ssl.yaml | compute.cnrm.cloud.google.com/v1alpha1 | ComputeManagedSSLCertificate | certificate-name-compute-sslcertificate | project-id-tier3 |

## Resource References

- [ComputeManagedSSLCertificate](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computemanagedsslcertificate)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gke/configconnector/gke-defaults/gateway-setup/ssl-certificate@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./ssl-certificate/"
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
