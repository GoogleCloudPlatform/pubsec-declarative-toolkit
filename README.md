# GCP PubSec Declarative Toolkit

The GCP PubSec Declarative Toolkit is a collection of declarative solutions to help you on your Journey to Google Cloud. Solutions are designed using [Config Connector](https://cloud.google.com/config-connector/docs/overview) and deployed using [Config Controller](https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-overview).

## Current Solutions


When getting a package the `@` indicates what tag or branch you will be getting with the `kpt pkg get` command. The current version is set for `v0.0.2-alpha` and should be stable but you can use `main` if you want the latest changes as they come in.

| Name | Description | Command | link |
| --- | --- | --- | --- |
| Guardrails | Base Infrastructure for 30 Day Guardrail Deployment | ```kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails@v0.0.2-alpha guardrails``` | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/guardrails) |
| Guardrails Policy Bundle | Policy Bundle to help analyze compliance for Guardrails | ```kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails-policies@v0.0.2-alpha guardrails-policies``` | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/guardrails-policies) |
| KCC Namespaces | This solution is a simple fork of the KCC Project Namespaces blueprint found [here](https://cloud.google.com/anthos-config-management/docs/tutorials/project-namespace-blueprint) | ```kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/kcc-namespaces@v0.0.2-alpha kcc-namespaces``` | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/kcc-namespaces) |
| Sandbox GKE | Private GKE deployment | ```kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/sandbox-gke@v0.0.2-alpha sandbox-gke``` | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/sandbox-gke) |
| Landing Zone | PBMM Landing Zone | ```kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/landing-zone@v0.0.3-alpha landing-zone``` | [link](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/landing-zone) |

## Quickstart

<!-- [![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git&cloudshell_workspace=.&cloudshell_tutorial=docs/cloudshell-tutorial.md) -->

In order to deploy the solutions we will need to activate a config-controller instance which we will then deploy a solution or solutions to it.

### arete cli Install

See arete [README](./cli/README.md) for installation instructions.

Once you have `arete` installed we can create the Config Controller environment by running:

```
arete create my-awesome-kcc --region=northamerica-northeast1 --project=target-project
```


### Advanced Install
Follow the following [guide](docs/advanced-install.md) to deploy a standalone Config Controller instance or see the examples [directory](examples/) for example installation methods.

## Additional Documentation

For further documentation on the project, including the setup pre-requirements see the 
- [Multi-Tenancy](https://cloud.google.com/anthos-config-management/docs/tutorials/project-namespace-blueprint)
- [Known Issues](docs/issues.md)

## Resources
- [Awesome KRM](https://github.com/askmeegs/learn-krm)
- [I do declare! Infrastructure automation with Configuration as Data](https://cloud.google.com/blog/products/containers-kubernetes/understanding-configuration-as-data-in-kubernetes)
- [Rationale Behind kpt](https://kpt.dev/guides/rationale)
- [KRM Blueprints](https://github.com/GoogleCloudPlatform/blueprints)

## Disclaimer

This is not an officially supported Google product.
