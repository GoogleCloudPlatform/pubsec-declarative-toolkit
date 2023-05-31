<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# client-project-setup


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Depends on `client-landing-zone`.

Package to create a client's project, 2 project scoped namespaces for its resources and a root sync.

## Setters

|             Name             |              Value              | Type | Count |
|------------------------------|---------------------------------|------|-------|
| client-management-project-id | client-management-project-12345 | str  |     1 |
| client-name                  | client1                         | str  |    50 |
| host-project-id              | net-host-project-12345          | str  |     7 |
| management-namespace         | config-control                  | str  |     8 |
| management-project-id        | management-project-12345        | str  |     2 |
| org-id                       |                      0000000000 | str  |     2 |
| project-billing-id           | AAAAAA-BBBBBB-CCCCCC            | str  |     1 |
| project-id                   | client-project-12345            | str  |    88 |
| project-parent-folder        | project-parent-folder           | str  |     2 |
| repo-branch                  | main                            | str  |     1 |
| repo-dir                     | csync/deploy/env                | str  |     1 |
| repo-url                     | git-repo-to-observe             | str  |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|               File               |                  APIVersion                   |              Kind              |                                    Name                                     |         Namespace          |
|----------------------------------|-----------------------------------------------|--------------------------------|-----------------------------------------------------------------------------|----------------------------|
| namespaces/project-id-tier3.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount              | project-id-tier3-sa                                                         | client-name-config-control |
| namespaces/project-id-tier3.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember                | project-id-tier3-sa-serviceaccountadmin-project-id-permissions              | client-name-projects       |
| namespaces/project-id-tier3.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember                | project-id-tier3-sa-securityadmin-project-id-permissions                    | client-name-projects       |
| namespaces/project-id-tier3.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember                | project-id-tier3-sa-tier3-firewallrule-admin-host-project-id-permissions    | client-name-projects       |
| namespaces/project-id-tier3.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember                | project-id-tier3-sa-tier3-dnsrecord-admin-host-project-id-permissions       | client-name-projects       |
| namespaces/project-id-tier3.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy               | project-id-tier3-sa-workload-identity-binding                               | client-name-config-control |
| namespaces/project-id-tier3.yaml | v1                                            | Namespace                      | project-id-tier3                                                            |                            |
| namespaces/project-id-tier3.yaml | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext         | configconnectorcontext.core.cnrm.cloud.google.com                           | project-id-tier3           |
| namespaces/project-id-tier3.yaml | rbac.authorization.k8s.io/v1                  | RoleBinding                    | cnrm-viewer-project-id-tier3                                                | client-name-networking     |
| namespaces/project-id-tier3.yaml | rbac.authorization.k8s.io/v1                  | RoleBinding                    | cnrm-viewer-project-id-tier3                                                | project-id-tier4           |
| namespaces/project-id-tier3.yaml | rbac.authorization.k8s.io/v1                  | RoleBinding                    | syncs-repo                                                                  | project-id-tier3           |
| namespaces/project-id-tier4.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount              | project-id-tier4-sa                                                         | client-name-config-control |
| namespaces/project-id-tier4.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember                | project-id-tier4-sa-editor-project-id-permissions                           | client-name-projects       |
| namespaces/project-id-tier4.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember                | project-id-tier4-sa-networkuser-host-project-id-permissions                 | client-name-projects       |
| namespaces/project-id-tier4.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember                | project-id-tier4-sa-instanceadmin-project-id-permissions                    | client-name-projects       |
| namespaces/project-id-tier4.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy               | project-id-tier4-sa-workload-identity-binding                               | client-name-config-control |
| namespaces/project-id-tier4.yaml | v1                                            | Namespace                      | project-id-tier4                                                            |                            |
| namespaces/project-id-tier4.yaml | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext         | configconnectorcontext.core.cnrm.cloud.google.com                           | project-id-tier4           |
| namespaces/project-id-tier4.yaml | rbac.authorization.k8s.io/v1                  | RoleBinding                    | cnrm-viewer-project-id-tier4                                                | client-name-networking     |
| namespaces/project-id-tier4.yaml | rbac.authorization.k8s.io/v1                  | RoleBinding                    | cnrm-viewer-project-id-tier4                                                | project-id-tier3           |
| namespaces/project-id-tier4.yaml | rbac.authorization.k8s.io/v1                  | RoleBinding                    | syncs-repo                                                                  | project-id-tier4           |
| project-iam.yaml                 | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember                | client-name-config-control-sa-iamserviceaccountadmin-project-id-permissions | client-name-projects       |
| project.yaml                     | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project                        | project-id                                                                  | client-name-projects       |
| project.yaml                     | compute.cnrm.cloud.google.com/v1beta1         | ComputeSharedVPCServiceProject | project-id-svpcservice                                                      | client-name-networking     |
| root-sync-git/root-sync-git.yaml | configsync.gke.io/v1beta1                     | RootSync                       | project-id-csync                                                            | config-management-system   |
| services.yaml                    | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                        | project-id-iam                                                              | client-name-projects       |
| services.yaml                    | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                        | project-id-resourcemanager                                                  | client-name-projects       |
| services.yaml                    | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                        | project-id-billing                                                          | client-name-projects       |
| services.yaml                    | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                        | project-id-serviceusage                                                     | client-name-projects       |

## Resource References

- RootSync
- [ComputeSharedVPCServiceProject](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computesharedvpcserviceproject)
- [ConfigConnectorContext](https://cloud.google.com/config-connector/docs/how-to/advanced-install#addon-configuring)
- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [IAMServiceAccount](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamserviceaccount)
- [Namespace](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#namespace-v1-core)
- [Project](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/project)
- [RoleBinding](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#rolebinding-v1-rbac-authorization-k8s-io)
- [Service](https://cloud.google.com/config-connector/docs/reference/resource-docs/serviceusage/service)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/client-project-setup@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd ".//solutions/client-project-setup/"
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
