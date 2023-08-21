# Namepsace Defaults

Landing zone v2 subpackage.
Depends on package `cluster-defaults`.
This package deploys to a GKE cluster.
It should be deployed once per workload namespace.

This package deploys a workload namespace and it's associated configuration.

---
Resources list:

- namespace
- resourcequota
- limitrange
- networkpolicies
- rolebinding for an application team
- a choice of Continuous Delivery(CD) solution which offer ConfigSync (Default) or ServiceAccount permission for external tools.
