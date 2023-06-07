<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# landing-zone


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
> **!!! This package is being deprecated. The resources it deploys have been consolidated in the core-landing-zone and experimentation/core-landing-zone package**
<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
public sector declarative toolkit - landing zone v2 solution

[Deploy a landing zone v2](../../docs/landing-zone-v2/README.md).

## Setters

|           Name            |          Value           | Type | Count |
|---------------------------|--------------------------|------|-------|
| audit-prj-id              | audit-prj-id-12345       | str  |     0 |
| audit-viewer              | group@domain.com         | str  |     0 |
| billing-id                |               0000000000 | str  |     0 |
| guardrails-project-id     | guardrails-project-12345 | str  |     0 |
| hub-project-id            | hub-project-12345        | str  |     0 |
| log-reader                | group@domain.com         | str  |     0 |
| log-writer                | group@domain.com         | str  |     0 |
| lz-folder-id              |               0000000000 | str  |    11 |
| management-namespace      | config-control           | str  |    32 |
| management-project-id     | management-project-12345 | str  |    64 |
| management-project-number |               0000000000 | str  |     3 |
| org-id                    |               0000000000 | str  |     5 |
| organization-viewer       | group@domain.com         | str  |     0 |

## Sub-packages

This package has no sub-packages.

## Resources

|                 File                 |              APIVersion              |          Kind          |                                 Name                                 |   Namespace    |
|--------------------------------------|--------------------------------------|------------------------|----------------------------------------------------------------------|----------------|
| namespaces/hierarchy.yaml            | iam.cnrm.cloud.google.com/v1beta1    | IAMServiceAccount      | hierarchy-sa                                                         | config-control |
| namespaces/hierarchy.yaml            | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | hierarchy-sa-folderadmin-permissions                                 | config-control |
| namespaces/hierarchy.yaml            | iam.cnrm.cloud.google.com/v1beta1    | IAMPartialPolicy       | hierarchy-sa-workload-identity-binding                               | config-control |
| namespaces/hierarchy.yaml            | v1                                   | Namespace              | hierarchy                                                            |                |
| namespaces/hierarchy.yaml            | core.cnrm.cloud.google.com/v1beta1   | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                    | hierarchy      |
| namespaces/hierarchy.yaml            | rbac.authorization.k8s.io/v1         | RoleBinding            | allow-hierarchy-resource-reference-from-projects                     | hierarchy      |
| namespaces/hierarchy.yaml            | rbac.authorization.k8s.io/v1         | RoleBinding            | allow-hierarchy-resource-reference-from-policies                     | hierarchy      |
| namespaces/hierarchy.yaml            | rbac.authorization.k8s.io/v1         | RoleBinding            | allow-hierarchy-resource-reference-from-config-control               | hierarchy      |
| namespaces/hierarchy.yaml            | rbac.authorization.k8s.io/v1         | RoleBinding            | allow-folders-resource-reference-to-logging                          | hierarchy      |
| namespaces/logging.yaml              | iam.cnrm.cloud.google.com/v1beta1    | IAMServiceAccount      | logging-sa                                                           | config-control |
| namespaces/logging.yaml              | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | logging-sa-logadmin-permissions                                      | config-control |
| namespaces/logging.yaml              | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | logging-sa-bigqueryadmin-permissions                                 | config-control |
| namespaces/logging.yaml              | iam.cnrm.cloud.google.com/v1beta1    | IAMPartialPolicy       | logging-sa-workload-identity-binding                                 | config-control |
| namespaces/logging.yaml              | v1                                   | Namespace              | logging                                                              |                |
| namespaces/logging.yaml              | core.cnrm.cloud.google.com/v1beta1   | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                    | logging        |
| namespaces/logging.yaml              | rbac.authorization.k8s.io/v1         | RoleBinding            | allow-logging-resource-reference-from-projects                       | logging        |
| namespaces/management-namespace.yaml | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | config-control-sa-orgroleadmin-permissions                           | config-control |
| namespaces/management-namespace.yaml | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | config-control-sa-management-project-editor-permissions              | config-control |
| namespaces/management-namespace.yaml | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | config-control-sa-management-project-serviceaccountadmin-permissions | config-control |
| namespaces/monitoring.yaml           | iam.cnrm.cloud.google.com/v1beta1    | IAMServiceAccount      | metrics-sa                                                           | config-control |
| namespaces/monitoring.yaml           | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | metrics-writer-permissions                                           | config-control |
| namespaces/monitoring.yaml           | iam.cnrm.cloud.google.com/v1beta1    | IAMPartialPolicy       | metrics-sa-workload-identity-binding                                 | config-control |
| namespaces/monitoring.yaml           | v1                                   | Namespace              | monitoring                                                           |                |
| namespaces/monitoring.yaml           | core.cnrm.cloud.google.com/v1beta1   | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                    | monitoring     |
| namespaces/networking.yaml           | iam.cnrm.cloud.google.com/v1beta1    | IAMServiceAccount      | networking-sa                                                        | config-control |
| namespaces/networking.yaml           | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | networking-sa-networkadmin-permissions                               | config-control |
| namespaces/networking.yaml           | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | networking-sa-security-permissions                                   | config-control |
| namespaces/networking.yaml           | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | networking-sa-dns-permissions                                        | config-control |
| namespaces/networking.yaml           | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | networking-sa-service-control-permissions                            | config-control |
| namespaces/networking.yaml           | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | networking-sa-xpnadmin-permissions                                   | config-control |
| namespaces/networking.yaml           | iam.cnrm.cloud.google.com/v1beta1    | IAMPartialPolicy       | networking-sa-workload-identity-binding                              | config-control |
| namespaces/networking.yaml           | v1                                   | Namespace              | networking                                                           |                |
| namespaces/networking.yaml           | core.cnrm.cloud.google.com/v1beta1   | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                    | networking     |
| namespaces/policies.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMServiceAccount      | policies-sa                                                          | config-control |
| namespaces/policies.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | policies-sa-orgpolicyadmin-permissions                               | config-control |
| namespaces/policies.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMPartialPolicy       | policies-sa-workload-identity-binding                                | config-control |
| namespaces/policies.yaml             | v1                                   | Namespace              | policies                                                             |                |
| namespaces/policies.yaml             | core.cnrm.cloud.google.com/v1beta1   | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                    | policies       |
| namespaces/projects.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMServiceAccount      | projects-sa                                                          | config-control |
| namespaces/projects.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | projects-sa-projectiamadmin-permissions                              | config-control |
| namespaces/projects.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | projects-sa-projectcreator-permissions                               | config-control |
| namespaces/projects.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | projects-sa-projectmover-permissions                                 | config-control |
| namespaces/projects.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | projects-sa-projectdeleter-permissions                               | config-control |
| namespaces/projects.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | projects-sa-serviceusageadmin-permissions                            | config-control |
| namespaces/projects.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMPolicyMember        | projects-sa-billinguser-permissions                                  | config-control |
| namespaces/projects.yaml             | iam.cnrm.cloud.google.com/v1beta1    | IAMPartialPolicy       | projects-sa-workload-identity-binding                                | config-control |
| namespaces/projects.yaml             | v1                                   | Namespace              | projects                                                             |                |
| namespaces/projects.yaml             | core.cnrm.cloud.google.com/v1beta1   | ConfigConnectorContext | configconnectorcontext.core.cnrm.cloud.google.com                    | projects       |
| namespaces/projects.yaml             | rbac.authorization.k8s.io/v1         | RoleBinding            | allow-projects-resource-reference-from-logging                       | projects       |
| namespaces/projects.yaml             | rbac.authorization.k8s.io/v1         | RoleBinding            | allow-projects-resource-reference-from-networking                    | projects       |
| namespaces/projects.yaml             | rbac.authorization.k8s.io/v1         | RoleBinding            | allow-projects-resource-reference-from-policies                      | projects       |
| services.yaml                        | blueprints.cloud.google.com/v1alpha1 | ProjectServiceSet      | management-project-id                                                | config-control |

## Resource References

- ProjectServiceSet
- [ConfigConnectorContext](https://cloud.google.com/config-connector/docs/how-to/advanced-install#addon-configuring)
- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [IAMServiceAccount](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamserviceaccount)
- [Namespace](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#namespace-v1-core)
- [RoleBinding](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#rolebinding-v1-rbac-authorization-k8s-io)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/landing-zone-v2@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd ".//solutions/landing-zone-v2/"
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