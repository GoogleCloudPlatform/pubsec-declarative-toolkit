# GKE Deployment

This folder contains the necessary files to deploy Standard and Autopilot GKE Clusters inside your experimentation landing-zone.

Scripts are being used to build Config Controller Clusters since deploying [Config Controller Instances](https://cloud.google.com/config-connector/docs/reference/resource-docs/configcontroller/configcontrollerinstance) using existing Clusters is still in in alpha and may change without notice. This does not apply to GKE Clusters.

### GKE Autopilot Cluster

You can deploy a GKE Autopilot Cluster using the instructions and krm resource manifest located inside the [gke-autopilot](gke-autopilot/) folder.

### GKE Standard Cluster

You can deploy a GKE Standard Cluster using the instructions and krm resource manifests located inside the [gke-standard](gke-standard/) folder.

### GKE Resource Examples

You will find a GKE example deploy based on Google's [Hello Application](https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/main/hello-app) example inside the [gke-resources/examples/hello-app](gke-resources/examples/hello-app/) folder.