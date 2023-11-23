<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# client-setup


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Depends on `core-landing-zone`.

Package to setup a client's namespaces, folder, management project and root sync.

## Setters

|             Name             |              Value              | Type | Count |
|------------------------------|---------------------------------|------|-------|
| client-billing-id            | AAAAAA-BBBBBB-CCCCCC            | str  |     1 |
| client-management-project-id | client-management-project-12345 | str  |   111 |
| client-name                  | client1                         | str  |   149 |
| dns-project-id               | dns-project-12345               | str  |     1 |
| management-namespace         | config-control                  | str  |    27 |
| management-project-id        | management-project-12345        | str  |     6 |
| management-project-number    |                      0000000000 | str  |     1 |
| org-id                       |                      0000000000 | str  |     3 |
| repo-branch                  | main                            | str  |     1 |
| repo-dir                     | csync/deploy/env                | str  |     1 |
| repo-url                     | git-repo-to-observe             | str  |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|                       File                       |                  APIVersion                   |          Kind          |                                          Name                                          |         Namespace          |
|--------------------------------------------------|-----------------------------------------------|------------------------|----------------------------------------------------------------------------------------|----------------------------|
| folder.yaml                                      | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder                 | clients.client-name                                                                    | hierarchy                  |
| mgmt-project/project.yaml                        | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project                | client-management-project-id                                                           | projects                   |
| mgmt-project/services.yaml                       | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | client-management-project-id-iam                                                       | projects                   |
| mgmt-project/services.yaml                       | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | client-management-project-id-resourcemanager                                           | projects                   |
| mgmt-project/services.yaml                       | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | client-management-project-id-billing                                                   | projects                   |
| mgmt-project/services.yaml                       | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | client-management-project-id-serviceusage                                              | projects                   |
| mgmt-project/services.yaml                       | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | client-management-project-id-container                                                 | projects                   |
| mgmt-project/services.yaml                       | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | client-management-project-id-ids                                                       | projects                   |
| mgmt-project/services.yaml                       | serviceusage.cnrm.cloud.google.com/v1beta1    | Service                | client-management-project-id-servicenetworking                                         | projects                   |
| namespaces/client-name-admin.yaml                | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | client-name-admin-sa                                                                   | client-name-config-control |
| namespaces/client-name-admin.yaml                | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | client-name-admin-sa-workload-identity-binding                                         | client-name-config-control |
| namespaces/client-name-admin.yaml                | v1                                            | Namespace              | client-name-admin                                                                      |                            |
| namespaces/client-name-admin.yaml                | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                                      | client-name-admin          |
| namespaces/client-name-admin.yaml                | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-resource-reference-from-client-name-admin                                        | client-name-projects       |
| namespaces/client-name-admin.yaml                | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-resource-reference-from-client-name-projects                                     | client-name-admin          |
| namespaces/client-name-admin.yaml                | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-resource-reference-from-client-name-admin                                        | client-name-networking     |
| namespaces/client-name-admin.yaml                | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-resource-reference-from-client-name-networking                                   | client-name-admin          |
| namespaces/client-name-hierarchy.yaml            | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | client-name-hierarchy-sa                                                               | client-name-config-control |
| namespaces/client-name-hierarchy.yaml            | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-hierarchy-sa-folderadmin-permissions                                       | hierarchy                  |
| namespaces/client-name-hierarchy.yaml            | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | client-name-hierarchy-sa-workload-identity-binding                                     | client-name-config-control |
| namespaces/client-name-hierarchy.yaml            | v1                                            | Namespace              | client-name-hierarchy                                                                  |                            |
| namespaces/client-name-hierarchy.yaml            | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                                      | client-name-hierarchy      |
| namespaces/client-name-hierarchy.yaml            | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-resource-reference-from-projects                                                 | client-name-hierarchy      |
| namespaces/client-name-hierarchy.yaml            | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-resource-reference-from-client-name-hierarchy                                    | hierarchy                  |
| namespaces/client-name-hierarchy.yaml            | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-client-name-hierarchy-resource-reference-from-policies                           | client-name-hierarchy      |
| namespaces/client-name-logging.yaml              | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | client-name-logging-sa                                                                 | client-name-config-control |
| namespaces/client-name-logging.yaml              | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-logging-sa-logadmin-permissions                                            | hierarchy                  |
| namespaces/client-name-logging.yaml              | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-logging-sa-monitoringadmin-permissions                                     | hierarchy                  |
| namespaces/client-name-logging.yaml              | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | client-name-logging-sa-workload-identity-binding                                       | client-name-config-control |
| namespaces/client-name-logging.yaml              | v1                                            | Namespace              | client-name-logging                                                                    |                            |
| namespaces/client-name-logging.yaml              | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                                      | client-name-logging        |
| namespaces/client-name-logging.yaml              | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-resource-reference-from-logging                                                  | client-name-projects       |
| namespaces/client-name-management-namespace.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | config-control-sa-iamserviceaccountadmin-client-management-project-id-permissions      | projects                   |
| namespaces/client-name-management-namespace.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | client-name-config-control-sa                                                          | config-control             |
| namespaces/client-name-management-namespace.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-config-control-sa-projectiamadmin-client-management-project-id-permissions | projects                   |
| namespaces/client-name-management-namespace.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-config-control-sa-iamserviceaccountadmin-client-folder-permissions         | hierarchy                  |
| namespaces/client-name-management-namespace.yaml | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | client-name-config-control-sa-workload-identity-binding                                | config-control             |
| namespaces/client-name-management-namespace.yaml | v1                                            | Namespace              | client-name-config-control                                                             |                            |
| namespaces/client-name-management-namespace.yaml | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                                      | client-name-config-control |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | client-name-networking-sa                                                              | client-name-config-control |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-networking-sa-networkadmin-permissions                                     | hierarchy                  |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-networking-sa-security-permissions                                         | hierarchy                  |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-networking-sa-dns-permissions                                              | hierarchy                  |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-networking-sa-tier2-dns-record-admin-permission                            | projects                   |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-networking-sa-service-control-permissions                                  | hierarchy                  |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-networking-sa-xpnadmin-permissions                                         | config-control             |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-networking-sa-servicedirectoryeditor-permissions                           | hierarchy                  |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-networking-sa-client-folder-org-resource-admin-permissions                 | hierarchy                  |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-networking-sa-cloudids-admin-permissions                                   | hierarchy                  |
| namespaces/client-name-networking.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | client-name-networking-sa-workload-identity-binding                                    | client-name-config-control |
| namespaces/client-name-networking.yaml           | v1                                            | Namespace              | client-name-networking                                                                 |                            |
| namespaces/client-name-networking.yaml           | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                                      | client-name-networking     |
| namespaces/client-name-networking.yaml           | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-resource-reference-from-networking                                               | client-name-projects       |
| namespaces/client-name-networking.yaml           | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-resource-reference-from-client-name-networking                                   | networking                 |
| namespaces/client-name-networking.yaml           | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-client-name-hierarchy-resource-reference-from-client-name-networking             | client-name-hierarchy      |
| namespaces/client-name-networking.yaml           | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-hierarchy-resource-reference-from-client-name-networking                         | hierarchy                  |
| namespaces/client-name-projects.yaml             | iam.cnrm.cloud.google.com/v1beta1             | IAMServiceAccount      | client-name-projects-sa                                                                | client-name-config-control |
| namespaces/client-name-projects.yaml             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-projects-sa-projectiamadmin-permissions                                    | hierarchy                  |
| namespaces/client-name-projects.yaml             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-projects-sa-projectcreator-permissions                                     | hierarchy                  |
| namespaces/client-name-projects.yaml             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-projects-sa-projectmover-permissions                                       | hierarchy                  |
| namespaces/client-name-projects.yaml             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-projects-sa-projectdeleter-permissions                                     | hierarchy                  |
| namespaces/client-name-projects.yaml             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-projects-sa-serviceusageadmin-permissions                                  | hierarchy                  |
| namespaces/client-name-projects.yaml             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember        | client-name-projects-sa-billinguser-permissions                                        | config-control             |
| namespaces/client-name-projects.yaml             | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy       | client-name-projects-sa-workload-identity-binding                                      | client-name-config-control |
| namespaces/client-name-projects.yaml             | v1                                            | Namespace              | client-name-projects                                                                   |                            |
| namespaces/client-name-projects.yaml             | core.cnrm.cloud.google.com/v1beta1            | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                                      | client-name-projects       |
| namespaces/client-name-projects.yaml             | rbac.authorization.k8s.io/v1                  | RoleBinding            | allow-resource-reference-from-projects                                                 | client-name-config-control |
| root-sync-git/root-sync-git.yaml                 | configsync.gke.io/v1beta1                     | RootSync               | client-name-csync                                                                      | config-management-system   |

## Resource References

- RootSync
- [ConfigConnectorContext](https://cloud.google.com/config-connector/docs/how-to/advanced-install#addon-configuring)
- [Folder](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/folder)
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
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/client-setup@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./client-setup/"
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
