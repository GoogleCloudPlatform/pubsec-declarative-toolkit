<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# ids-endpoint


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
`ids` subpackage.

Deploy this package once per IDS endpoint. You can have multiple copies of this subpackage by cloning the entire folder to a new folder (i.e. subpackage2)

A package to deploy a Cloud Intrusion Detection System (IDS) endpoint and packet mirroring policy.

Warning! It requires the alpha CRD [cloudidsendpoint](https://github.com/GoogleCloudPlatform/k8s-config-connector/blob/master/crds/cloudids_v1alpha1_cloudidsendpoint.yaml)
loaded in the config controller.

[Install alpha CRDS](https://cloud.google.com/config-connector/docs/how-to/install-alpha-crds)

## Setters

|            Name             |                                            Value                                              | Type | Count |
|-----------------------------|-----------------------------------------------------------------------------------------------|------|-------|
| client-name                 | client1                                                                                       | str  |     4 |
| endpoint-name               | endpoint1                                                                                     | str  |     5 |
| filter                      |                                                                                               | str  |     0 |
| host-project-id             | net-host-project-12345                                                                        | str  |     6 |
| host-project-vpc            | projects/<host-project-id>/global/networks/global-standard-vpc                                | str  |     2 |
| ids-endpoint-forwardingrule | `https://www.googleapis.com/compute/v1/projects/<uid>/regions/<region>/forwardingRules/<uid>` | str  |     1 |
| mirroredresources           |                                                                                               | str  |     0 |
| region                      | northamerica-northeast1                                                                       | str  |     1 |
| severity                    | LOW                                                                                           | str  |     1 |
| zone                        | northamerica-northeast1-a                                                                     | str  |     2 |

## Sub-packages

This package has no sub-packages.

## Resources

|      File      |               APIVersion                |          Kind          |                 Name                 |       Namespace        |
|----------------|-----------------------------------------|------------------------|--------------------------------------|------------------------|
| endpoint.yaml  | cloudids.cnrm.cloud.google.com/v1alpha1 | CloudIDSEndpoint       | host-project-id-endpoint-name-ids    | client-name-networking |
| mirroring.yaml | compute.cnrm.cloud.google.com/v1beta1   | ComputePacketMirroring | host-project-id-endpoint-name-mirror | client-name-networking |

## Resource References

- [CloudIDSEndpoint](https://cloud.google.com/config-connector/docs/reference/resource-docs/cloudids/cloudidsendpoint)
- [ComputePacketMirroring](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computepacketmirroring)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/ids/ids-endpoint@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./ids-endpoint/"
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
