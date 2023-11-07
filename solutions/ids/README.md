<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# ids


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Depends on `client-landing-zone` package.

Package to create Cloud Intrusion Detection System (IDS) resources inside the network host project. This is required for PBMM.

Warning! It requires the alpha CRD [cloudidsendpoint](https://github.com/GoogleCloudPlatform/k8s-config-connector/blob/master/crds/cloudids_v1alpha1_cloudidsendpoint.yaml)
loaded in the config controller.

[Install alpha CRDS](https://cloud.google.com/config-connector/docs/how-to/install-alpha-crds)

This package needs to be deployed in multiple steps because the `ComputePacketMirroring` resource in the endpoint subpackage requires the `endpointForwardingRule` value of the `CloudIDSEndpoint` resource.

1. customize the setters but leave the field `data.ids-endpoint-forwardingrule` in the file `endpoint\setters.yaml` untouched.

2. deploy the package

3. wait until the `CloudIDSEndpoint` is `UpToDate`, then run the command below to obtain it's `endpointForwardingRule` value.

    ```bash
    gcloud ids endpoints describe <endpoint-name> --zone <zone> --project <host-project-id>
    ```

4. update the field `data.ids-endpoint-forwardingrule` in the file `endpoint\setters.yaml`

5. re-deploy the updated package.

## Setters

|            Name             |                             Value                              | Type  | Count |
|-----------------------------|----------------------------------------------------------------|-------|-------|
| address                     | 10.254.0.0                                                     | str   |     1 |
| client-name                 | client1                                                        | str   |    14 |
| endpoint-name               | endpoint-name                                                  | str   |     5 |
| firewall-address            | [10.254.0.0/16]                                                | array |     1 |
| host-project-id             | net-host-project-12345                                         | str   |    25 |
| host-project-vpc            | projects/<host-project-id>/global/networks/global-standard-vpc | str   |     2 |
| ids-endpoint-forwardingrule | ids-endpoint-forwardingrule                                    | str   |     1 |
| region                      | region                                                         | str   |     1 |
| severity                    | severity                                                       | str   |     1 |
| zone                        | zone                                                           | str   |     2 |

## Sub-packages

- [ids-endpoint](endpoint)

## Resources

|     File      |                   APIVersion                    |            Kind             |                        Name                         |       Namespace        |
|---------------|-------------------------------------------------|-----------------------------|-----------------------------------------------------|------------------------|
| address.yaml  | compute.cnrm.cloud.google.com/v1beta1           | ComputeAddress              | host-project-id-standard-google-managed-services-ip | client-name-networking |
| firewall.yaml | compute.cnrm.cloud.google.com/v1beta1           | ComputeFirewall             | host-project-id-standard-egress-allow-psa-fwr       | client-name-networking |
| peering.yaml  | servicenetworking.cnrm.cloud.google.com/v1beta1 | ServiceNetworkingConnection | host-project-id-standard-to-googlemanaged-peer      | client-name-networking |
| services.yaml | serviceusage.cnrm.cloud.google.com/v1beta1      | Service                     | host-project-id-ids                                 | client-name-projects   |
| services.yaml | serviceusage.cnrm.cloud.google.com/v1beta1      | Service                     | host-project-id-servicenetworking                   | client-name-projects   |

## Resource References

- [ComputeAddress](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeaddress)
- [ComputeFirewall](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewall)
- [ServiceNetworkingConnection](https://cloud.google.com/config-connector/docs/reference/resource-docs/servicenetworking/servicenetworkingconnection)
- [Service](https://cloud.google.com/config-connector/docs/reference/resource-docs/serviceusage/service)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/ids@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./ids/"
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
