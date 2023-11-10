# Namespace Defaults

Landing zone v2 subpackage.
Depends on package `cluster-defaults`.
This package deploys to a GKE cluster.
It should be deployed once per workload namespace.

## Description

This solution will create a dedicated namespace intended to contain an applications. In addition to the namespace, it also creates a number of related namespaced Kubernetes resources that should be created and configured by default.

Below table describes components provisioned by this solution.

| **Component**                      | **Filename**                     |*Description**                                                                                                                                        |
|------------------------------------|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| Limit Range                        | limitrange.yaml                  | Implements a `LimitRange` to place constraints on the resource allocations by application pods within the namespace.                                 |
| Service Account                    | namespace-sa.yaml                | Implements a workload identity service account that can be used by pods to access GCP API                                                            |
| Namespace                          | namespace.yaml                   | Implements the namespace.                                                                                                                            |
| Network Policy                     | networkpolicy.yaml               | Implements a default network policy to enforce network security within the namespace.                                                                |
| Resource Quotas                    | resourcequota.yaml               | Implements a `ResourceQuota` constraint that limits aggregate resource consumption in the namespace.                                                 |
| Rolebinding for Gateway HTTPRoutes | rolebinding-httproute-admin.yaml | Implements permissions required by the Gateway controller to manage HTTPRoute resources.                                                             |
| Rolebinding for Client Team        | rolebinding-human-view.yaml      | Implements read/view permissions to be granted to the application team.                                                                              |
| Config Sync                        | cd/gitops-config-sync.yaml       | Implements a GitOps solution using ConfigSync to deploy/update of Kubernetes resources related to application.                                       |
| Rolebinding for CI/CD              | cd/cd-rolebinding.yaml           | Implements permissions to enable an external CI/CD system to deploy/update of Kubernetes resources related to application. **NOTE**: This component is not enabled by default. |

### Limit Range

By default, containers run with unbounded compute resources on a Kubernetes cluster. Kubernetes resource quotas can restrict consumption and creation of cluster resources (such as CPU time, memory, and persistent storage) within a specified namespace. Within a namespace, a Pod can consume as much CPU and memory as is allowed by the `ResourceQuotas` that apply to that namespace. You might also be concerned about making sure that a single object cannot monopolize all available resources within a namespace.

A `LimitRange` is a constraint on the resource allocations for application Pods in a namespace. They are useful so that a single object cannot monopolize all available resources within a namespace.

A `LimitRange` provides constraints that can:

- Enforce minimum and maximum compute resources usage per Pod or Container in a namespace.
- Enforce minimum and maximum storage request per PersistentVolumeClaim in a namespace.
- Enforce a ratio between request and limit for a resource in a namespace.
- Set default request/limit for compute resources in a namespace and automatically inject them to Containers at runtime.

The values should be configured based on requirements of the applications deployed in the namespace and size of nodes in the cluster.

### Network Policy

Network policy specify how a pod is allowed to communicate over the network and control the traffic flow at the IP address or port level (OSI layer 3 or 4). They serve as a Kubernetes level implementation of firewall rules.

The implementation sets a number of default rules for pods within the namespace:

- Allow ingress/egress communication to all pods within the same namespace.
- Allow ingress from gateway namespace.
- Allow ingress from Google Network Load Balancer for health checks
- Allow egress to Google metadata server
- Allow egress for Google Workload Identity
- Allow egress for to Google DNS services
- Allow egress to Google API.

### Resource Quota

A Kubernetes `ResourceQuota` API provides constraints that limit aggregate resource consumption per namespace. It can limit the quantity of objects that can be created in a namespace by type, as well as the total amount of compute resources that may be consumed by resources in that namespace.
If creating or updating a resource in a namespace violates a quota constraint, the request will fail (HTTP status code 403 FORBIDDEN) with a message explaining the constraint that would have been violated.

Some common valued that are set in resource quotas are:

- The memory request total for all Pods in a namespace
- The memory limit total for all Pods in a namespace
- The CPU request total for all Pods in a namespace
- The CPU limit total for all Pods in a namespace
- Total number of Pods that can run in a namespace

### Rolebinding for Gateway HTTPRoutes

Gateway API is Kubernetes API that implements ingress of traffic into a Kubernetes cluster.  The Gateway Controller is the Kubernetes component that is responsible for this task. It requires permissions to manage Kubernetes `HTTPRoute` resource in order to achieve this functionality.

### Rolebinding for Client Team

Application team should be granted read/view permissions to the namespace. This can be achieved using the standard `view` Kubernetes cluster role.

To efficiently manage tenant permissions in a cluster, RBAC permissions should be bound to Google Groups. The membership of those groups are maintained by Google Workspace administrators.

### Config Sync

Implements a GitOps solution that observes a git repository and applies the manifest located in the specified folder.

### Rolebinding for CI/CD

> **NOTE**: This component is not enabled by default.

Application teams may want to use a third party CI/CD solution for deploying application inside their Kubernetes namespace. To facilitate this scenario, a service account for the deployment system is needed. This service account should be granted sufficient permissions to the namespace to deploy/update Kubernetes resources related to their application.
This can be achieved using the standard `edit` Kubernetes cluster role.

Kubernetes RBAC permissions should be bound to Google IAM Service Account representing the CI/CD system.
