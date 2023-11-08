<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# gke-defaults


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Depends on package `gke-setup`.
Requires project-id-tier3 namespace.

Deploy this package once per service project.

A package to deploy common GKE resources. It include roles granted to a user or group for vizualizing GKE.

Warning! It requires the alpha CRD [computmanagedsslcertificate](https://github.com/GoogleCloudPlatform/k8s-config-connector/blob/master/crds/compute_v1alpha1_computemanagedsslcertificate.yaml)
loaded in the config controller.

[Install alpha CRDS](https://cloud.google.com/config-connector/docs/how-to/install-alpha-crds)

## Setters

|       Name       |           Value           | Type  | Count |
|------------------|---------------------------|-------|-------|
| certificate-id   |                  12345678 | int   |     1 |
| certificate-name | certificate-name          | str   |     3 |
| client-name      | client1                   | str   |     8 |
| dns-project-id   | dns-project-id            | str   |     1 |
| domains          | [example.com]             | array |     1 |
| gateway-name     | gateway-name              | str   |     3 |
| host-project-id  | host-project-12345        | str   |     0 |
| metadata-name    | metadata-name             | str   |     1 |
| project-id       | project-12345             | str   |    12 |
| spec-name        | dns-name                  | str   |     1 |
| team-gkeviewer   | group:client1@example.com | str   |     6 |

## Sub-packages

- [dns](gateway-setup/dns)
- [gateway-setup](gateway-setup)
- [ssl-certificate](gateway-setup/ssl-certificate)

## Resources

|       File       |            APIVersion             |      Kind       |                 Name                  | Namespace |
|------------------|-----------------------------------|-----------------|---------------------------------------|-----------|
| project-iam.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPolicyMember | containerclusterviewer-permissions    |           |
| project-iam.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPolicyMember | loggingviewer-permissions             |           |
| project-iam.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPolicyMember | monitoringviewer-permissions          |           |
| project-iam.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPolicyMember | monitoringdashboardeditor-permissions |           |
| project-iam.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPolicyMember | pubsubviewer-permissions              |           |
| project-iam.yaml | iam.cnrm.cloud.google.com/v1beta1 | IAMPolicyMember | pubsubsubscriber-permissions          |           |

## Resource References

- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gke/configconnector/gke-defaults@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./gke-defaults/"
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
