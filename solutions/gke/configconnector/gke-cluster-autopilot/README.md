<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# gke-cluster-autopilot


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Depends on package `gke-setup`.
Requires project-id-tier3 namespace.

Deploy this package once per GKE cluster.

A GKE Autopilot Cluster running in a service project. This package also deploys a dedicated subnet inside the host project.

## Setters

|              Name               |                     Value                      | Type  | Count |
|---------------------------------|------------------------------------------------|-------|-------|
| client-name                     | client1                                        | str   |    18 |
| cluster-name                    | autopilot1-gke                                 | str   |    36 |
| gke-to-azdo-priority            |                                           2000 | int   |     1 |
| gke-to-docker-priority          |                                           2002 | int   |     1 |
| gke-to-github-priority          |                                           2001 | int   |     1 |
| host-project-id                 | host-project-12345                             | str   |     6 |
| host-project-vpc                | host-project-vpc                               | str   |     2 |
| location                        | northamerica-northeast1                        | str   |     5 |
| master-authorized-networks-cidr | [cidrBlock: 10.1.1.5/32displayName: bastion]   | array |     1 |
| masterIpv4CidrBlock             | 172.16.0.0/28                                  | str   |     1 |
| masterIpv4Range                 | ["172.16.0.0/28"]                              | array |     0 |
| podIpv4Range                    | ["240.1.0.0/21"]                               | array |     1 |
| primaryIpv4Range                | ["10.1.32.0/24"]                               | array |     3 |
| project-id                      | project-12345                                  | str   |    51 |
| repo-branch                     | main                                           | str   |     1 |
| repo-dir                        | csync/tier3/kubernetes/<fleet-id>/deploy/<env> | str   |     1 |
| repo-url                        | tier34-repo-to-observe                         | str   |     1 |
| subnet-pod-cidr                 | 240.1.0.0/21                                   | str   |     1 |
| subnet-primary-cidr             | 10.1.32.0/24                                   | str   |     1 |
| subnet-services-cidr            | 10.1.33.0/24                                   | str   |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|                      File                       |               APIVersion                |           Kind            |                                Name                                 |    Namespace     |
|-------------------------------------------------|-----------------------------------------|---------------------------|---------------------------------------------------------------------|------------------|
| application-infrastructure-folder/firewall.yaml | compute.cnrm.cloud.google.com/v1beta1   | ComputeFirewallPolicyRule | project-id-cluster-name-egress-allow-azdo                           | project-id-tier3 |
| application-infrastructure-folder/firewall.yaml | compute.cnrm.cloud.google.com/v1beta1   | ComputeFirewallPolicyRule | project-id-cluster-name-egress-allow-github                         | project-id-tier3 |
| application-infrastructure-folder/firewall.yaml | compute.cnrm.cloud.google.com/v1beta1   | ComputeFirewallPolicyRule | project-id-cluster-name-egress-allow-docker                         | project-id-tier3 |
| gke.yaml                                        | container.cnrm.cloud.google.com/v1beta1 | ContainerCluster          | autopilot1-gke                                                      | project-id-tier3 |
| gkehub-featuremembership-acm.yaml               | gkehub.cnrm.cloud.google.com/v1beta1    | GKEHubFeatureMembership   | cluster-name-acm-hubfeaturemembership                               | project-id-tier3 |
| gkehub-membership.yaml                          | gkehub.cnrm.cloud.google.com/v1beta1    | GKEHubMembership          | cluster-name                                                        | project-id-tier3 |
| host-project/firewall.yaml                      | compute.cnrm.cloud.google.com/v1beta1   | ComputeFirewall           | project-id-cluster-name-lb-health-check                             |                  |
| host-project/subnet.yaml                        | compute.cnrm.cloud.google.com/v1beta1   | ComputeSubnetwork         | project-id-cluster-name-snet                                        |                  |
| kms.yaml                                        | kms.cnrm.cloud.google.com/v1beta1       | KMSKeyRing                | cluster-name-kmskeyring                                             | project-id-tier3 |
| kms.yaml                                        | kms.cnrm.cloud.google.com/v1beta1       | KMSCryptoKey              | cluster-name-etcd-key                                               | project-id-tier3 |
| service-account.yaml                            | iam.cnrm.cloud.google.com/v1beta1       | IAMServiceAccount         | cluster-name-sa                                                     | project-id-tier3 |
| service-account.yaml                            | iam.cnrm.cloud.google.com/v1beta1       | IAMPolicyMember           | cluster-name-sa-logwriter-permissions                               | project-id-tier3 |
| service-account.yaml                            | iam.cnrm.cloud.google.com/v1beta1       | IAMPolicyMember           | cluster-name-sa-metricwriter-permissions                            | project-id-tier3 |
| service-account.yaml                            | iam.cnrm.cloud.google.com/v1beta1       | IAMPolicyMember           | cluster-name-sa-monitoring-viewer-permissions                       | project-id-tier3 |
| service-account.yaml                            | iam.cnrm.cloud.google.com/v1beta1       | IAMPolicyMember           | cluster-name-sa-storage-object-viewer-permissions                   | project-id-tier3 |
| service-account.yaml                            | iam.cnrm.cloud.google.com/v1beta1       | IAMPolicyMember           | cluster-name-sa-stackdriver-metadata-writer-permissions             | project-id-tier3 |
| service-account.yaml                            | iam.cnrm.cloud.google.com/v1beta1       | IAMPolicyMember           | cluster-name-sa-artifactregistry-reader-permissions                 | project-id-tier3 |
| service-account.yaml                            | iam.cnrm.cloud.google.com/v1beta1       | IAMPolicyMember           | cluster-name-sa-secretmanager-secretaccessor-permissions            | project-id-tier3 |
| service-account.yaml                            | iam.cnrm.cloud.google.com/v1beta1       | IAMPolicyMember           | project-id-tier3-sa-serviceaccount-user-cluster-name-sa-permissions | project-id-tier3 |

## Resource References

- [ComputeFirewallPolicyRule](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewallpolicyrule)
- [ComputeFirewall](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewall)
- [ComputeSubnetwork](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computesubnetwork)
- [ContainerCluster](https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containercluster)
- [GKEHubFeatureMembership](https://cloud.google.com/config-connector/docs/reference/resource-docs/gkehub/gkehubfeaturemembership)
- [GKEHubMembership](https://cloud.google.com/config-connector/docs/reference/resource-docs/gkehub/gkehubmembership)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [IAMServiceAccount](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamserviceaccount)
- [KMSCryptoKey](https://cloud.google.com/config-connector/docs/reference/resource-docs/kms/kmscryptokey)
- [KMSKeyRing](https://cloud.google.com/config-connector/docs/reference/resource-docs/kms/kmskeyring)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gke/configconnector/gke-cluster-autopilot@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./gke-cluster-autopilot/"
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
