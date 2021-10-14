# GCP Canadian PubSec Sandbox

This Repo contains the configuration to deploy a Sandbox Environment based off on the GoC's 30 Day [Guardrails](https://github.com/canada-ca/cloud-guardrails).

## Prerequisites
- GCP Account
- [Cloud Shell](https://cloud.google.com/shell#:~:text=Cloud%20Shell%20is%20an%20online,tool%2C%20kubectl%2C%20and%20more.)
- [kpt](https://kpt.dev/)
- git

## Quickstart
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox.git&cloudshell_workspace=.&cloudshell_tutorial=docs/cloudshell-tutorial.md)

## What is in the Sandbox

### Org Policies
- Restrict VM External Access
- Require Trusted Images
- Restrict VPC Peering
- Require Shielded VMs
- Resource Locations
- Disable VPC External IPV6
- Disable Service Account Key Creation
- Enforce Uniform bucket-level IAM Access and management
- Requires OS login for any SSH/RDP needs
- Only GC organization's customer directory ID will be allowed as IAM entity in GCP, this will block all other GSuite organization, including Gmail accounts.



### Folder Structure
- Guardrails
    - Guardrails-configs
- Protected B Workloads
- Unclassified Workloads

### Services
- [Private GKE Instance](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters)
- [Artifact Registry](https://cloud.google.com/artifact-registry)
- [Secret Manager](https://cloud.google.com/secret-manager#:~:text=Secret%20Manager%20is%20a%20secure,audit%20secrets%20across%20Google%20Cloud.)
- [BinaryAuthorization](https://cloud.google.com/binary-authorization)
- [Anthos](https://anthos.dev/)