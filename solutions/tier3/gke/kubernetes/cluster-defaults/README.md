# Cluster Defaults

Landing zone v2 subpackage.
Depends on package `gke-cluster-autopilot`.
This package deploys to a GKE cluster.
It should be deployed once per cluster.

This package deploys default resources that have to exist on all clusters.

---
Resources list:

- Gateway Controller
  - Gateway namespace
  - Gateway using an external global load balancer and a SSL certificate
  - Attaches an SSL Policy
  - Attaches a Cloud Armor and logging policy
