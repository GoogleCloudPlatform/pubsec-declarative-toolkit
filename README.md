# GCP PubSec Declarative Toolkit

This GCP PubSec Declarative Toolkit is a collection of declarative solutions to help you on your Journey to Google Cloud. Solutions are designed using [Config Connector](https://cloud.google.com/config-connector/docs/overview).

## Current Solutions
| Name | Description | Command | link |
| --- | --- | --- | --- |
| Guardrails | Base Infrastructure for 30 Day Guardrail Deployment | `kpt pkg get git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git/solutions/guardrails guardrails` | [link](https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox/tree/main/solutions/guardrails) |
| Guardrails Policy Bundle | Policy Bundle to help analyze compliance for Guardrails | `kpt pkg get git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git/solutions/guardrails-policies guardrails-policies` | [link](https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox/tree/main/solutions/guardrails-policies) |
| KCC Namespaces | This solution is a simple fork of the KCC Project Namespaces blueprint found [here](https://cloud.google.com/anthos-config-management/docs/tutorials/project-namespace-blueprint) | `kpt pkg get git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git/solutions/kcc-namespaces kcc-namespaces` | [link](https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox/tree/main/solutions/kcc-namespaces) |
| Sandbox GKE | Private GKE deployment | `kpt pkg get git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git/solutions/sandbox-gke sandbox-gke` | [link](https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox/tree/main/solutions/sandbox-gke) |


## Quickstart

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git&cloudshell_workspace=.&cloudshell_tutorial=docs/cloudshell-tutorial.md)

### Dependencies

### Documentation

For further documentation on the project, including the setup pre-requirements see the [Documentation Site](https://reimagined-meme-7df92d3b.pages.github.io/).

### Additional Resources
- [Awesome KRM](https://github.com/askmeegs/learn-krm)
- [I do declare! Infrastructure automation with Configuration as Data](https://cloud.google.com/blog/products/containers-kubernetes/understanding-configuration-as-data-in-kubernetes)
- [Rationale Behind kpt](https://kpt.dev/guides/rationale)

## Disclaimer

This is not an officially supported Google product.
