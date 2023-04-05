# root-syncs

This folder contains an example of a Config Sync `RootSync` manifest that you can use to deploy Google Cloud configurations from a source of truth.

## Config Sync

Config sync can be used to deploy GCP and GKE resources using manifest files in YAML format.

> *With Config Sync, you can manage Kubernetes resources by using files, called configs, that are stored in a source of truth. Config Sync supports Git repositories, OCI images, and Helm charts as sources of truth. This page shows you how to enable and configure Config Sync so that it syncs from your root repository. Config Sync is available if you use Anthos or Google Kubernetes Engine (GKE).*

<https://cloud.google.com/anthos-config-management/docs/how-to/installing-config-sync>

---

Scripts are being used to build Config Controller Clusters since deploying [Config Controller Instances](https://cloud.google.com/config-connector/docs/reference/resource-docs/configcontroller/configcontrollerinstance) using existing Clusters is still in in alpha and may change without notice. This does not apply to GKE Clusters.

<https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containercluster>
<br><https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containernodepool>
<br><https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containercluster#autopilot_cluster>

These examples uses single `RootSync` configuration:
<br><https://cloud.google.com/anthos-config-management/docs/how-to/multiple-repositories#manage-root-repos>

More information can be found here:
<br><https://cloud.google.com/anthos-config-management/docs/config-sync-overview>

