Solutions
=========

What is a Solution Sandbox
--------------------------

This repostory contains a series of [KRM](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/) (Kubernetes Resource Model) `kpt` packages needed to deploy Sandbox Environments in Google Cloud. [kpt](https://kpt.dev/) is a Git-native, schema-aware, extensible client-side tool for packaging, customizing, validating, and applying Kubernetes resources.

Each `kpt` package contains configuration files to be used with a [Config Connector](https://cloud.google.com/config-connector/docs/overview) enabled Kubernetes Cluster or using the [Config Controller](https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-overview) service.

These packages will container a package for Guardrails and a package for the associated Servce(s). For example the `sandbox-gke` bundles the `guardrails` and `private-gke` bundles to create its sandbox environment.

Available Sandbox Solutions
---------------------------

Sandbox

Command

Private GKE Cluster

`kpt pkg get git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git/solutions/sandbox-gke`

### GKE Sandbox

The following services will be deployed into a GKE-Sandbox folder for learning and development. - [Private GKE Instance](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters) - [Artifact Registry](https://cloud.google.com/artifact-registry) - [Secret Manager](https://cloud.google.com/secret-manager#:~:text=Secret%20Manager%20is%20a%20secure,audit%20secrets%20across%20Google%20Cloud.) - [BinaryAuthorization](https://cloud.google.com/binary-authorization) - [Anthos](https://anthos.dev/)

[Previous Governance](../governance/)

[Next Known Issues](../issues/)