# Deploy Autopilot GKE Cluster

These instructions will help you deploy a GKE Autopilot Cluster inside your project.

> Pre-requisite: You must deploy an [autopilot](../../../kcc-deploy/kcc-autopilot/deploy-kcc-autopilot.sh) or [standard](../../../kcc-deploy/kcc-standard/deploy-kcc-standard.sh) Config Controller cluster before proceeding.

## Deployment Options

> Important: Please make sure to edit the [setters.yaml](setters.yaml) file as it contains important variables.

> The following steps require the kpt cli:
> <br>https://kpt.dev/installation/kpt-cli

You can quickly get started by changing the `project-id` value to your assigned project id. You can set other values as well.

```yaml
data:
  # Please replace ${project-id} with your assigned project id
  project-id: scemu-sp-testproj
  project-namespace: config-control
```

Render the configuration files once your `project-id` has been set. To do this run the following command inside this folder `krm-resources/deploy/gke-autopilot`.

Starting at the root of this repo run the following:

```sh
cd krm-resources/deploy/gke-autopilot
kpt fn render
```

> Results should look like this:

```console
Package "gke":
[RUNNING] "gcr.io/kpt-fn/apply-setters:v0.2"
[PASS] "gcr.io/kpt-fn/apply-setters:v0.2" in 700ms
  Results:
    [info] metadata.name: set field value to "exp-cluster"
    [info] metadata.namespace: set field value to "config-control"
    [info] metadata.labels.cluster: set field value to "exp-cluster"
    [info] metadata.annotations.cnrm.cloud.google.com/project-id: set field value to "scemu-sp-kcc-exp"
    ...(14 line(s) truncated, use '--truncate-output=false' to disable)

Successfully executed 1 function(s) in 1 package(s).
```

You are now ready to deploy the GKE cluster using any of the following options.

### Option 1 - Using KPT

You can use the kpt cli:
<br>https://kpt.dev/installation/kpt-cli

`kpt live init`
<br>https://kpt.dev/reference/cli/live/init/
<br>Initializes the configuration

`kpt live apply`
<br>https://kpt.dev/reference/cli/live/apply/
<br>Applies the configuration

`kpt live destroy`
<br>https://kpt.dev/reference/cli/live/destroy/
<br>Destroys the configuration

**Steps**

1. Starting at the root of this repo run the following command to initialize the config:

    ```sh
    cd krm-resources/deploy/gke-autopilot
    kpt live init
    ```

    > Expected output

    ```console
    initializing "resourcegroup.yaml" data (namespace: config-control)...success
    ```

1. From this folder execute the apply command to deploy the GKE Autopilot.

    > This step will take 5 minutes or more to complete. Please monitor the output on the console as this command is live.

    ```sh
    kpt live apply
    ```

    > Example status result

    ```console
    installing inventory ResourceGroup CRD.
    inventory update started
    inventory update finished
    apply phase started
    configmap/setters apply successful
    containercluster.container.cnrm.cloud.google.com/exp-cluster apply successful
    apply phase finished
    reconcile phase started
    configmap/setters reconcile successful
    containercluster.container.cnrm.cloud.google.com/exp-cluster reconcile pending
    containercluster.container.cnrm.cloud.google.com/exp-cluster reconcile successful
    reconcile phase finished
    apply phase started
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 apply successful
    apply phase finished
    reconcile phase started
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 reconcile pending
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 reconcile successful
    reconcile phase finished
    inventory update started
    inventory update finished
    apply result: 3 attempted, 3 successful, 0 skipped, 0 failed
    reconcile result: 3 attempted, 3 successful, 0 skipped, 0 failed, 0 timed out
    ```

1.  Your GKE cluster is now ready!

> Destroy Instructions for GKE

> These instructions does not delete the Config Controller cluster.

1. Run this command inside `krm-resources/deploy/gke-autopilot`

    ```sh
    kpt live destroy
    ```

    > This step will take 5 minutes or more to complete. Please monitor the output on the console as this command is live.

    > Example status result

    ```console
    delete phase started
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 delete successful
    delete phase finished
    reconcile phase started
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 reconcile pending
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 reconcile successful
    reconcile phase finished
    delete phase started
    containercluster.container.cnrm.cloud.google.com/exp-cluster delete successful
    configmap/setters delete successful
    delete phase finished
    reconcile phase started
    containercluster.container.cnrm.cloud.google.com/exp-cluster reconcile pending
    configmap/setters reconcile pending
    configmap/setters reconcile successful
    containercluster.container.cnrm.cloud.google.com/exp-cluster reconcile successful
    reconcile phase finished
    inventory update started
    inventory update finished
    delete result: 3 attempted, 3 successful, 0 skipped, 0 failed
    reconcile result: 3 attempted, 3 successful, 0 skipped, 0 failed, 0 timed out
    ```

1.  Your GKE cluster is now deleted!

1. Manaually delete the file `resourcegroup.yaml` from the gke-autopilot folder.

    ```sh
    rm resourcegroup.yaml
    ```

### Option 2 - Using kubectl

Using the `kubectl` cli:
<br>https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#install_kubectl

**Steps**

  > Note: If you previously tried Option 1, make sure that you have deleted the file `resourcegroup.yaml` from the gke-autopilot folder.

1. Run the following command to deploy the GKE Cluster and Node Pool manifests.

    Starting at the root of this repo run the following:

    ```sh
    cd krm-resources/deploy/gke-autopilot
    kubectl apply -f gke-autopilot.yaml
    ```

    > This step will take 5 minutes or more to complete.

    > Example status result

    ```console
    containercluster.container.cnrm.cloud.google.com/exp-cluster created
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 created
    ```

    > Please monitor the progress from the Kubernetes Engine Console or via the following commands.

    From krm-resources/deploy/gke-autopilot:

    ```sh
    kubectl describe containercluster.container.cnrm.cloud.google.com/exp-cluster
    kubectl describe containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1
    ```

1.  Deleting the GKE Cluster and Node Pool.

    > Destroy Instructions for GKE

    > These instructions does not delete the Config Controller cluster. # TODO KCC deletion script/steps

    From krm-resources/deploy/gke-autopilot run:

    > Please monitor the progress from the Kubernetes Engine Console or wait until this command completes.

    ```sh
    kubectl delete -f container-cluster.yaml; kubectl delete -f container-nodepool.yaml
    ```

    > Example result

    ```console
    containercluster.container.cnrm.cloud.google.com/exp-cluster deleted
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 deleted
    ```

### Option 3 - Using Config Sync

Config sync can be used to deploy GCP and GKE resources using manifest files in YAML format.

While deploying [Config Controller](https://cloud.google.com/config-connector/docs/reference/resource-docs/configcontroller/configcontrollerinstance) using config sync is currently in alpha and may change without notice, you can deploy GKE clusters including node pools.

https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containercluster
<br>https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containernodepool


The following example will use a single `RootSync` configuration:
<br>https://cloud.google.com/anthos-config-management/docs/how-to/multiple-repositories#manage-root-repos

More information can be found here:
<br>https://cloud.google.com/anthos-config-management/docs/config-sync-overview

This example will use three `RootSync` manifest files, one to deploy the GKE Cluster and a worker node pool, one for Google Cloud resources and one for GKE resources.
<br>

Example code will be hosted in an Azure DevOps repo. Google Cloud and GKE resources will be stored in seperate folders inside this repo.

This example will use the following folder structure.

Starting at the root of this repo:

- Manifest files will be stored in krm-resources
- GCP resource manifest files will be stored in krm-resources/deploy/gcp-resources
  - The gke-autopilot can be deployed using config sync
- GKE resource manifest files will be stored in krm-resources/deploy/gke-resources
- RootSync manifests will be stored in krm-resources/root-syncs (Not managed by Config Sync)

```console
.
├── README.md
├── TODO.md
├── kcc-deploy
│   ├── README.md
│   ├── common
│   │   └── print-colors.sh
│   ├── kcc-autopilot
│   │   ├── README.md
│   │   ├── deploy-kcc-autopilot.sh
│   │   └── destroy-kcc-autopilot.sh
│   └── kcc-standard
│       ├── README.md
│       ├── deploy-kcc-standard.sh
│       └── destroy-kcc-standard.sh
└── krm-resources
    ├── README.md
    ├── deploy
    │   ├── README.md
    │   ├── gcp-resources
    │   │   └── examples
    │   │       ├── README.md
    │   │       └── storage-bucket.yaml
    │   ├── gke-autopilot
    │   │   ├── Kptfile
    │   │   ├── README.md
    │   │   ├── gke-autopilot.yaml
    │   │   └── setters.yaml
    │   ├── gke-resources
    │   │   └── examples
    │   │       └── hello-app
    │   │           ├── README.md
    │   │           ├── helloweb-deployment.yaml
    │   │           ├── helloweb-hpa.yaml
    │   │           ├── helloweb-ingress-static-ip.yaml
    │   │           └── helloweb-service-load-balancer.yaml
    │   └── gke-standard
    │       ├── Kptfile
    │       ├── README.md
    │       ├── container-cluster.yaml
    │       ├── container-nodepool.yaml
    │       └── setters.yaml
    └── root-syncs
        ├── README.md
        ├── root-sync-gcp-resources.yaml
        ├── root-sync-gke-autopilot.yaml
        ├── root-sync-gke-resources.yaml
        └── root-sync-gke-standard.yaml
```

Config sync status can be retrieved using the `nomos status` command.

> Note: External IP redacted from output

  ```console
  Connecting to clusters...
  I0316 10:10:01.991200   15340 request.go:601] Waited for 1.1372862s due to client-side throttling, not priority and   fairness, request: GET:https://x.x.x.x/apis/sourcerepo.cnrm.cloud.google.com/v1beta1?timeout=3s

  *gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster
    --------------------
    UNKNOWN   No RootSync or RepoSync resources found
  ```

#### Implementing Config Sync

The following will guide you during the setup of Config Sync.

**Steps**

  > Note: If you previously tried Option 1, make sure that you have deleted the file `resourcegroup.yaml` from the gke-autopilot folder.

1. Create a git-creds secret.

    You need to create a kubernetes secret that grants "code read" permission.

    > Note: This example will use an Azure Devops Repo. Further info can be found on this site: https://cloud.google.com/anthos-config-management/docs/how-to/    installing-config-sync#git-creds-secret.

1. Configure the following environment variables:

    ```
    export GIT_USERNAME=<git username> # For Azure Devops, this is the name of the Organization
    export TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    ```

1. Create `git-creds` secret with the required value to access the git repositories

    ```bash
    kubectl create secret generic git-creds --namespace="config-management-system" --from-literal=username=${GIT_USERNAME} --from-literal=token=${TOKEN}
    ```

    > Example output of command

    ```console
    secret/git-creds created
    ```
#### Deploy GKE using Config Sync

1. You can create a RootSync file for the GKE cluster using these instructions.

    root-sync-gke-autopilot.yaml

    ```yaml
    # Root sync for GKE Cluster
    apiVersion: configsync.gke.io/v1beta1
    kind: RootSync
    metadata:
      name: root-sync-git-gke-autopilot
      namespace: config-management-system
    spec:
      sourceFormat: unstructured
      override:
      git:
        repo: https://gc-cpa@dev.azure.com/gc-cpa/iac-gcp-dev/_git/gcp-stjeanl1-client-kcc-gke
        branch: main
        dir: krm-resources/deploy/gke-autopilot
        auth: token
        secretRef:
          name: git-creds
    ```

1. Apply the root-sync-gke-autopilot.yaml. This will setup the config sync for the gke deployment. Run `nomos status` to check on the status of the RootSync. You can also refresh the status by polling the status using the `--poll` flag: `nomos status --poll=30s`

    Starting at the root of this repo run the following:

    ```sh
    cd krm-resources/root-syncs
    kubectl apply -f root-sync-gke-autopilot.yaml
    ```

    Keep checking the status using `nomos status` or `nomos status --poll=30s`.

    > Example output during deployment

    ```console
    *gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster
    --------------------
    <root>:root-sync-git-gke-cluster         https://gc-cpa@dev.azure.com/gc-cpa/iac-gcp-dev/_git/gcp-stjeanl1-client-kcc-gke/krm-resources/deploy/gke-cluster@main
    SYNCED @ 2023-03-16 10:36:11 -0400 EDT   516df4b170a37d676498d3f84c9be804ec9a2063
    Managed resources:
       NAMESPACE        NAME                                                                    STATUS    SOURCEHASH
       config-control   containercluster.container.cnrm.cloud.google.com/exp-cluster   Current   516df4b
          Update in progress
       config-control   containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1   Current   516df4b
          reference ContainerCluster config-control/exp-cluster is not ready
       default   configmap/setters   Current   516df4b
    ```

    > Example output of successful deployment

    ```console
    *gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster
    --------------------
    <root>:root-sync-git-gke-autopilot         https://gc-cpa@dev.azure.com/gc-cpa/iac-gcp-dev/_git/gcp-stjeanl1-client-kcc-gke/krm-resources/deploy/gke-cluster@main
    SYNCED @ 2023-03-16 10:36:11 -0400 EDT   516df4b170a37d676498d3f84c9be804ec9a2063
    Managed resources:
       NAMESPACE        NAME                                                                          STATUS    SOURCEHASH
       config-control   containercluster.container.cnrm.cloud.google.com/exp-cluster         Current   516df4b
       config-control   containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1   Current   516df4b
       default          configmap/setters
    ```
1. Your GKE Cluster is ready!

#### Destroy your GKE Cluster using Config Sync

> These instructions does not delete the Config Controller cluster.

1.    To delete entire cluster and node pool you can follow these steps.

      Starting at the root of this repo run the following:

      > WARNING: If you delete the cluster and node pool before the root sync, config sync will reconcile automatically and start re-deploy the cluster and node  ool.

      ```sh
      cd krm-resources/root-syncs
      kubectl delete -f root-sync-gke-autopilot.yaml
      kubectl delete containercluster.container.cnrm.cloud.google.com/exp-cluster
      kubectl delete containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1
      ```
      > Expected result
      ```console
      rootsync.configsync.gke.io "root-sync-git-gke-autopilot" deleted
      containercluster.container.cnrm.cloud.google.com "exp-cluster" deleted
      containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 deleted
      ```

### TODO
1. Create a RootSync file for gcp resources in krm-resources/root-syncs

    root-sync-gcp-resources.yaml

    ```yaml
    # Root sync for GCP Resources
    apiVersion: configsync.gke.io/v1beta1
    kind: RootSync
    metadata:
      name: root-sync-git-gcp-resources
      namespace: config-management-system
    spec:
      sourceFormat: unstructured
      override:
      git:
        repo: https://gc-cpa@dev.azure.com/gc-cpa/iac-gcp-dev/_git/gcp-stjeanl1-client-kcc-gke
        branch: main
        dir: krm-resources/deploy/gcp-resources
        auth: token
        secretRef:
          name: git-creds
    ```

1. Create a RootSync file for gke resources in krm-resources/root-syncs

    `root-sync-gke-resources.yaml`

    ```yaml
    # Root sync for GKE Resources
    apiVersion: configsync.gke.io/v1beta1
    kind: RootSync
    metadata:
      name: root-sync-git-gke-resources
      namespace: config-management-system
    spec:
      sourceFormat: unstructured
      override:
      git:
        repo: https://gc-cpa@dev.azure.com/gc-cpa/iac-gcp-dev/_git/gcp-stjeanl1-client-kcc-gke
        branch: main
        dir: krm-resources/deploy/gke-resources
        auth: token
        secretRef:
          name: git-creds
    ```

1. Apply the

