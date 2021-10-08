# GCP Canadian PubSec Sandbox

This Repo contains the configuration to deploy a Sandbox Environment based off on the GoC's 30 Day [Guardrails](https://github.com/canada-ca/cloud-guardrails).

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

### Folder Structure
- Guardrails
    - Guardrails-configs
- Protected B Workloads
- Unclassified Workloads

### Services
- Private GKE Instance
- Artifact Registry
- Secret Manager
- BinAuth
- Anthos