<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# client-project


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing Zone v2 experimentation subpackage.
Depends on 'client-landing-zone'

Package to create a client's project.
This package should only be deployed within a experimentation landing zone.

## Setters

|         Name          |          Value          | Type | Count |
|-----------------------|-------------------------|------|-------|
| project-billing-id    | AAAAAA-BBBBBB-CCCCCC    | str  |     1 |
| project-editor        | group:team1@example.com | str  |     2 |
| project-id            | xxemu-team1-projectname | str  |    61 |
| project-parent-folder | project-parent-folder   | str  |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|        File         |                  APIVersion                   |       Kind        |                   Name                    | Namespace  |
|---------------------|-----------------------------------------------|-------------------|-------------------------------------------|------------|
| network/dns.yaml    | dns.cnrm.cloud.google.com/v1beta1             | DNSPolicy         | project-id-logging-dnspolicy              | networking |
| network/nat.yaml    | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouterNAT  | project-id-nane1-nat                      | networking |
| network/nat.yaml    | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouter     | project-id-nane1-router                   | networking |
| network/nat.yaml    | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouterNAT  | project-id-nane2-nat                      | networking |
| network/nat.yaml    | compute.cnrm.cloud.google.com/v1beta1         | ComputeRouter     | project-id-nane2-router                   | networking |
| network/route.yaml  | compute.cnrm.cloud.google.com/v1beta1         | ComputeRoute      | project-id-internet-egress-route          | networking |
| network/subnet.yaml | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork | project-id-nane1-vpc1-paz-snet            | networking |
| network/subnet.yaml | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork | project-id-nane1-vpc1-apprz-snet          | networking |
| network/subnet.yaml | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork | project-id-nane1-vpc1-datarz-snet         | networking |
| network/subnet.yaml | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork | project-id-nane2-vpc1-paz-snet            | networking |
| network/subnet.yaml | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork | project-id-nane2-vpc1-apprz-snet          | networking |
| network/subnet.yaml | compute.cnrm.cloud.google.com/v1beta1         | ComputeSubnetwork | project-id-nane2-vpc1-datarz-snet         | networking |
| network/vpc.yaml    | compute.cnrm.cloud.google.com/v1beta1         | ComputeNetwork    | project-id-global-vpc1-vpc                | networking |
| project-iam.yaml    | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember   | project-id-editor-permissions             | projects   |
| project-iam.yaml    | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember   | project-id-iam-security-admin-permissions | projects   |
| project.yaml        | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project           | project-id                                | projects   |
| services.yaml       | serviceusage.cnrm.cloud.google.com/v1beta1    | Service           | project-id-compute                        | projects   |
| services.yaml       | serviceusage.cnrm.cloud.google.com/v1beta1    | Service           | project-id-dns                            | projects   |

## Resource References

- [ComputeNetwork](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computenetwork)
- [ComputeRoute](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeroute)
- [ComputeRouterNAT](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computerouternat)
- [ComputeRouter](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computerouter)
- [ComputeSubnetwork](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computesubnetwork)
- [DNSPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/dns/dnspolicy)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [Project](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/project)
- [Service](https://cloud.google.com/config-connector/docs/reference/resource-docs/serviceusage/service)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/experimentation/client-project@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./client-project/"
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
