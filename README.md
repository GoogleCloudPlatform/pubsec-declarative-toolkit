# GCP PubSec Declarative Toolkit

The GCP PubSec Declarative Toolkit is a collection of declarative solutions to help you on your Journey to Google Cloud. Solutions are designed using [Config Connector](https://cloud.google.com/config-connector/docs/overview) and deployed using [Config Controller](https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-overview).

## Current Solutions

| Name | Description | Documentation |
| --- | --- | --- |
| Guardrails | Base Infrastructure for 30 Day Guardrail Deployment | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/guardrails) |
| Organization Policy Bundle | Package of Baseline Organization Policies | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/org-policies) |
| Guardrails Policy Bundle | Policy Bundle to help analyze compliance for Guardrails |  [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/guardrails-policies) |
| KCC Namespaces | This solution is a simple fork of the KCC Project Namespaces blueprint found [here](https://cloud.google.com/anthos-config-management/docs/tutorials/project-namespace-blueprint) | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/kcc-namespaces) |
| Sandbox GKE | Private GKE deployment | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/sandbox-gke) |
| Landing Zone v2 (LZv2) | **(In development)** PBMM Landing Zone built in collaboration with Shared Services Canada |  [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/docs/landing-zone-v2/README.md)
| Gatekeeper Policy (LZv2) | Policy Bundle | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/gatekeeper-policies) |
| Core Landing Zone (LZv2) | Foundational resources building the landing zone | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/core-landing-zone) |
| Client Setup (LZv2) | Package to create the initial client folder and namespaces | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/client-setup) |
| Client Landing Zone (LZv2)  | Package to create the client folder sub-structure and a standard Shared VPC | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/client-landing-zone) |
| Client Project Setup (LZv2) | Package to create a service project and host workloads | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/client-project-setup) |

When getting a package you can use the `@` to indicate what tag or branch you will be getting with the `kpt pkg get` command for example `kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/core-landing-zone@main`.

You can find the latest release versions in the `releases` [page](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/releases).

## Quickstart

Deploying an example landing zone requires two steps:
- A [Config Connector](https://cloud.google.com/config-connector/docs/overview) enabled Kubernetes cluster
- One or more [solutions](#current-solutions) packages like the [core-landing-zone](solutions/core-landing-zone) and [experimentation core-landing-zone](solutions/experimentation/core-landing-zone) documented in section 2 of [landing-zone-v2](docs/landing-zone-v2#2-create-your-landing-zone)
  
In order to deploy the [solutions](#current-solutions) you will need a Kubernetes cluster with [Config Connector](https://cloud.google.com/config-connector/docs/overview) installed.

We recommend using the Managed Config Controller service which comes bundled with [Config Connector](https://cloud.google.com/config-connector/docs/overview) and [Anthos Config Management](https://cloud.google.com/anthos/config-management), alternatively you can [install](https://cloud.google.com/config-connector/docs/how-to/advanced-install#manual) Config Connector on any CNCF compliant Kubernetes cluster.

See the Google Cloud [quickstart](https://cloud.google.com/anthos-config-management/docs/tutorials/manage-resources-config-controller) guide for getting up and running with Config Controller

A setup script is provided in the repository [gcp-tools](https://github.com/ssc-spc-ccoe-cei/gcp-tools/blob/main/scripts/bootstrap/setup-kcc.sh) that will configure the Config Controller cluster.  The instructions in the [Advanced Install](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/docs/advanced-install.md) are automated as part of the [setup-kcc.sh](https://github.com/ssc-spc-ccoe-cei/gcp-tools/blob/main/scripts/bootstrap/setup-kcc.sh) script.

We have also put together the following [guide](docs/advanced-install.md) to deploy a standalone Config Controller instance or see the examples [directory](examples/) for example installation methods.

After the Kubernetes cluster is fully provisioned - proceed to [Deploy a landing zone v2 package](docs/landing-zone-v2/README.md).

## Additional Documentation

You may want to look at the [documentation](https://github.com/ssc-spc-ccoe-cei/gcp-documentation) published by **[Shared Services Canada](https://www.canada.ca/en/shared-services.html)**, providing a good level of details on how they have implemented the [Landing Zone v2 solution](docs/landing-zone-v2/README.md) to host workloads from any of the 43 departments of the Government of Canada.

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
