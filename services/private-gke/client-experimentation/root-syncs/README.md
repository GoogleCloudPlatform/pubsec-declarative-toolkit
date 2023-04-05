# root-syncs

This folder contains manifest files to deploy Config Sync RootSync configurations.

Four examples are provided:

|File|Description|
|----|-----------|
| [root-sync-gcp-resources.yaml](root-sync-gcp-resources.yaml)  | Creates a RootSync for gcp-resources located inside the [deploy/gcp-resources](../deploy/gcp-resources/) folder      |
| [root-sync-gke-autopilot.yaml](root-sync-gke-autopilot.yaml)  | Creates a RootSync for the GKE Autopilot Cluster deployment located inside the [deploy/gke-autopilot](../deploy/gke-autopilot) folder      |
| [root-sync-gke-resources.yaml](root-sync-gke-resources.yaml)  | Creates a RootSync for gke-resources located inside the [deploy/gke-resources](../deploy/gke-resources/) folder      |
| [root-sync-gke-standard.yaml](root-sync-gke-standard.yaml)    | Creates a RootSync for the GKE Autopilot Cluster deployment located inside the [deploy/gke-standard](../deploy/gke-standard/) folder      |

## Config Sync

Config sync can be used to deploy GCP and GKE resources using manifest files in YAML format.

> *With Config Sync, you can manage Kubernetes resources by using files, called configs, that are stored in a source of truth. Config Sync supports Git repositories, OCI images, and Helm charts as sources of truth. This page shows you how to enable and configure Config Sync so that it syncs from your root repository. Config Sync is available if you use Anthos or Google Kubernetes Engine (GKE).*

<https://cloud.google.com/anthos-config-management/docs/how-to/installing-config-sync>

---

While deploying [Config Controller](https://cloud.google.com/config-connector/docs/reference/resource-docs/configcontroller/configcontrollerinstance) using config sync is currently in alpha and may change without notice, you can deploy GKE Standard or Autopilot Clusters.

<https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containercluster>
<br><https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containernodepool>
<br><https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containercluster#autopilot_cluster>

These examples uses single `RootSync` configuration:
<br><https://cloud.google.com/anthos-config-management/docs/how-to/multiple-repositories#manage-root-repos>

More information can be found here:
<br><https://cloud.google.com/anthos-config-management/docs/config-sync-overview>