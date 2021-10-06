# What this Kpt Package does

Deploys Sandbox ENV based off of the GoC's 30 Day Guardrails

## Org Policies
- Restrict VM External Access
- Require Trusted Images
- Restrict VPC Peering
- Require Shielded VMs
- Resource Locations
- Disable VPC External IPV6
- Disable Service Account Key Creation

## Folder Structure
- Guardrails
    - Guardrails-configs
- Protected B Workloads
- Unclassified Workloads


## Services
- Private GKE Instance
- Artifact Registry
- Secret Manager
- BinAuth
- Anthos