# GCP PubSec Declarative Toolkit

The GCP PubSec Declarative Toolkit is a collection of declarative solutions to help you on your Journey to Google Cloud. Solutions are designed using [Config Connector](https://cloud.google.com/config-connector/docs/overview) and deployed using [Config Controller](https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-overview).

## Current Solutions

| Name | Description | Documentation |
| --- | --- | --- |
| Guardrails | Base Infrastructure for 30 Day Guardrail Deployment | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/guardrails) |
| Organization Policy Bundle | Package of Baseline Organization Policies | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/org-policies) |
| Guardrails Policy Bundle | Policy Bundle to help analyze compliance for Guardrails |  [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/guardrails-policies) |
| KCC Namespaces | This solution is a simple fork of the KCC Project Namespaces blueprint found [here](https://cloud.google.com/anthos-config-management/docs/tutorials/project-namespace-blueprint) | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/kcc-namespaces) |
| Landing Zone v2 (LZv2) | **(In development)** PBMM Landing Zone built in collaboration with Shared Services Canada |  [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/docs/landing-zone-v2/README.md)
| Gatekeeper Policy (LZv2) | Policy Bundle | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/gatekeeper-policies) |
| Core Landing Zone (LZv2) | Foundational resources building the landing zone | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/core-landing-zone) |
| Client Setup (LZv2) | Package to create the initial client folder and namespaces | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/client-setup) |
| Client Landing Zone (LZv2)  | Package to create the client folder sub-structure and a standard Shared VPC | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/client-landing-zone) |
| Client Project Setup (LZv2) | Package to create a service project and host workloads | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/client-project-setup) |
| GKE Setup (LZv2) | Package to prepare a service project for GKE clusters | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/gke/configconnector/gke-setup) |
| GKE Defaults (LZv2) | A package to deploy common GKE resources | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/gke/configconnector/gke-defaults) |
| GKE Cluster Autopilot (LZv2) | A GKE Autopilot Cluster running in a service project | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/gke/configconnector/gke-cluster-autopilot) |
| Cluster Defaults (LZv2) | This package deploys default resources that have to exist on all GKE clusters | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/gke/kubernetes/cluster-defaults) |
| Namespace Defaults (LZv2) | This package deploys a workload namespace and it's associated configuration | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/gke/kubernetes/namespace-defaults) |

When getting a package you can use the `@` to indicate what tag or branch you will be getting with the `kpt pkg get` command for example `kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/core-landing-zone@main`.

You can find the latest release versions in the `releases` [page](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/releases).

## Quickstart

Deploying an example landing zone requires two steps:
- A [Config Connector](https://cloud.google.com/config-connector/docs/overview) enabled Kubernetes cluster
- One or more [solutions](#current-solutions) packages like the [core-landing-zone](solutions/core-landing-zone) and [experimentation core-landing-zone](solutions/experimentation/core-landing-zone) documented in section 2 of [landing-zone-v2](docs/landing-zone-v2#2-create-your-landing-zone)

In order to deploy the [solutions](#current-solutions) you will need a Kubernetes cluster with [Config Connector](https://cloud.google.com/config-connector/docs/overview) installed.

We recommend using the Managed Config Controller service which comes bundled with [Config Connector](https://cloud.google.com/config-connector/docs/overview) and [Anthos Config Management](https://cloud.google.com/anthos/config-management), alternatively you can [install](https://cloud.google.com/config-connector/docs/how-to/advanced-install#manual) Config Connector on any CNCF compliant Kubernetes cluster.

See the Google Cloud [quickstart](https://cloud.google.com/anthos-config-management/docs/tutorials/manage-resources-config-controller) guide for getting up and running with Config Controller

We have put together the following [guide](docs/advanced-install.md) to deploy a standalone Config Controller instance or see the examples [directory](examples/) for example installation methods.

After the Kubernetes cluster is fully provisioned - proceed to [Deploy a landing zone v2 package](docs/landing-zone-v2/README.md).

## Additional Documentation

For further documentation on the project, including the setup pre-requirements and supporting service such as Config Connector and Config Management.

- [Multi-Tenancy](https://cloud.google.com/anthos-config-management/docs/tutorials/project-namespace-blueprint)
- [Scalability Guidelines](https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-scalability)
- [View Config Controller Status](https://cloud.google.com/anthos-config-management/docs/how-to/config-controller-repo-status)
- [Monitor Resources](https://cloud.google.com/config-connector/docs/how-to/monitoring-your-resources)
- [Config Connector Resources](https://cloud.google.com/config-connector/docs/reference/overview)
- [Config Connector OSS on GitHub](https://github.com/GoogleCloudPlatform/k8s-config-connector)
- [Known Issues](docs/issues.md)
- [Fleet Management at Spotify (Part 2): The Path to Declarative Infrastructure](https://engineering.atspotify.com/2023/05/fleet-management-at-spotify-part-2-the-path-to-declarative-infrastructure/)

## Additional Resources

- [Awesome KRM](https://github.com/askmeegs/learn-krm)
- [I do declare! Infrastructure automation with Configuration as Data](https://cloud.google.com/blog/products/containers-kubernetes/understanding-configuration-as-data-in-kubernetes)
- [Rationale Behind kpt](https://kpt.dev/guides/rationale)
- [KRM Blueprints](https://github.com/GoogleCloudPlatform/blueprints)
- [How Goldman Sachs manages Google Cloud resources with Anthos Config Management at Google Next](https://www.youtube.com/watch?v=5ENId064XLo)

## Disclaimer

This is not an officially supported Google product.
