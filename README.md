# GCP PubSec Declarative Toolkit

The GCP PubSec Declarative Toolkit is a collection of declarative solutions to help you on your Journey to Google Cloud. Solutions are designed using [Config Connector](https://cloud.google.com/config-connector/docs/overview) and deployed using [Config Controller](https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-overview).

## Current Solutions
| Name | Description | Command | link |
| --- | --- | --- | --- |
| Guardrails | Base Infrastructure for 30 Day Guardrail Deployment | `kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails guardrails` | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/guardrails) |
| Guardrails Policy Bundle | Policy Bundle to help analyze compliance for Guardrails | `kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails-policies guardrails-policies` | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/guardrails-policies) |
| KCC Namespaces | This solution is a simple fork of the KCC Project Namespaces blueprint found [here](https://cloud.google.com/anthos-config-management/docs/tutorials/project-namespace-blueprint) | `kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/kcc-namespaces kcc-namespaces` | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/kcc-namespaces) |
| Sandbox GKE | Private GKE deployment | `kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/sandbox-gke sandbox-gke` | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/sandbox-gke) |


## Quickstart

<!-- [![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=git@github.com:GoogleCloudPlatform/pubsec-declarative-toolkit.git&cloudshell_workspace=.&cloudshell_tutorial=docs/cloudshell-tutorial.md) -->

In order to deploy the solutions we will need to activate a config-controller instance which we will then deploy a solution or solutions to it.

1. Download the `arete` cli

```
wget .....
```

2. Creat the Config Controller Instance.
```
arete create config-control <name>
```

For a custom install please see the following [guide](docs/advanced-install.md)

### Additional Documentation

For further documentation on the project, including the setup pre-requirements see the 
- [Advanced Install](docs/advanced-install.md).
- [Multi-Tenancy](https://cloud.google.com/anthos-config-management/docs/tutorials/project-namespace-blueprint)
- [Known Issues](docs/issues.md)

### Resources
- [Awesome KRM](https://github.com/askmeegs/learn-krm)
- [I do declare! Infrastructure automation with Configuration as Data](https://cloud.google.com/blog/products/containers-kubernetes/understanding-configuration-as-data-in-kubernetes)
- [Rationale Behind kpt](https://kpt.dev/guides/rationale)

## Disclaimer

This is not an officially supported Google product.
