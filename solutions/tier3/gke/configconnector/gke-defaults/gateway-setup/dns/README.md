<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# dns


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
gateway-setup subpackage.
Requires project-id-tier3 namespace.

Deploy this package once per dns record resources. You can have multiple copies of this subpackage by cloning the entire folder to a new folder (i.e. subpackage2)

This package deploys a dns a record that is required by a kubernetes gateway (Gateway Controller).

## Setters

|      Name      |          Value           | Type | Count |
|----------------|--------------------------|------|-------|
| client-name    | client1                  | str  |     2 |
| dns-project-id | dns-project-12345        | str  |     1 |
| gateway-name   | sample-gateway           | str  |     1 |
| metadata-name  | sample-name-recordset    | str  |     1 |
| project-id     | project-12345            | str  |     2 |
| spec-name      | sample-name.example.com. | str  |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|   File   |            APIVersion             |     Kind     |     Name      |    Namespace     |
|----------|-----------------------------------|--------------|---------------|------------------|
| dns.yaml | dns.cnrm.cloud.google.com/v1beta1 | DNSRecordSet | metadata-name | project-id-tier3 |

## Resource References

- [DNSRecordSet](https://cloud.google.com/config-connector/docs/reference/resource-docs/dns/dnsrecordset)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gke/configconnector/gke-defaults/gateway-setup/dns@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./dns/"
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
