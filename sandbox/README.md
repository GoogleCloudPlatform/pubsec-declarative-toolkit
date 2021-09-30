# What this Kpt Package does

Deploys Sandbox ENV based off of the GoC's 30 Day Guardrails

## Org Policies
- No External IPs
- Trusted Images
- No VPC Peering
- Shielded Nodes

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