# Deploy Autopilot GKE Cluster

These instructions will help you deploy a GKE Autopilot Cluster inside your project.

> Pre-requisite: You must deploy an [autopilot](../../../private-kcc/client-experimentation/kcc-autopilot/deploy-kcc-autopilot.sh) or [standard](../../../private-kcc/client-experimentation/kcc-standard/deploy-kcc-standard.sh) Config Controller cluster before proceeding.

## Deployment Options

> Important: Please make sure to edit the [setters.yaml](setters.yaml) file as it contains important variables.

> The following steps require the kpt cli:
> <br>https://kpt.dev/installation/kpt-cli

To quickly get started, change the following values inside the `setters.yaml` file:

- project-id
- cluster-name
- cluster-description

Render the configuration files once your values have been set. Starting at the root of this repo run the following:

```sh
cd services/private-gke/client-experimentation/gke-autopilot
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

You are now ready to deploy the GKE Autopilot cluster using any of the following options.

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
    cd services/private-gke/client-experimentation/gke-autopilot
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

> These instructions does not delete the Config Controller cluster.

1. Run this command inside `services/private-gke/client-experimentation/gke-autopilot`

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

1. Manaually delete the file `resourcegroup.yaml` from the `gke-autopilot` folder.

    ```sh
    rm resourcegroup.yaml
    ```

### Option 2 - Using kubectl

Using the `kubectl` cli:
<br>https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#install_kubectl

**Steps**

  > Note: If you previously tried Option 1, make sure that you have deleted the file `resourcegroup.yaml` from the `gke-autopilot` folder.

1. Run the following command to deploy the GKE Autopilot Cluster.

    Starting at the root of this repo run the following:

    ```sh
    cd services/private-gke/client-experimentation/gke-autopilot
    kubectl apply -f gke-autopilot.yaml
    ```

    > This step will take 5 minutes or more to complete.

    > Example status result

    ```console
    containercluster.container.cnrm.cloud.google.com/exp-cluster created
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 created
    ```

    > Please monitor the progress from the Kubernetes Engine Console or via the following commands.

    ```sh
    kubectl describe containercluster.container.cnrm.cloud.google.com/exp-cluster
    kubectl describe containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1
    ```

1.  Deleting the GKE Autopilot Cluster.

    > These instructions does not delete the Config Controller cluster.

    > Please monitor the progress from the Kubernetes Engine Console or wait until this command completes.

    From services/private-gke/client-experimentation/gke-autopilot:

    ```sh
    kubectl delete -f gke-autopilot.yaml
    ```

    > Example result

    ```console
    containercluster.container.cnrm.cloud.google.com/exp-cluster deleted
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 deleted
    ```

### Option 3 - Using Config Sync

Config sync is a GitOps service offered as part of Anthos and is built on an [open source core](https://github.com/GoogleContainerTools/kpt-config-sync). It's included in Config Controller.

We can use Config Sync to manage GCP and GKE resources.

https://cloud.google.com/anthos-config-management/docs/config-sync-overview
<br>https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-overview
<br>https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containercluster
<br>https://cloud.google.com/config-connector/docs/reference/resource-docs/container/containernodepool

The following example will use a single `RootSync` configuration:
<br>https://cloud.google.com/anthos-config-management/docs/how-to/multiple-repositories#manage-root-repos

More information can be found here:
<br>https://cloud.google.com/anthos-config-management/docs/config-sync-overview

#### RootSync example

This example will use a [RootSync](../root-syncs/root-sync-gke-autopilot.yaml).

Change the following variables to match your Git Repo config.

CONFIG_SYNC_REPO
<br>CONFIG_SYNC_DIR

```yaml
# Root sync for GKE Autopilot Cluster
apiVersion: configsync.gke.io/v1beta1
kind: RootSync
metadata:
  name: root-sync-git-gke-autopilot
  namespace: config-management-system
spec:
  sourceFormat: unstructured
  override:
  git:
    repo: ${CONFIG_SYNC_REPO}
    branch: main
    dir: ${CONFIG_SYNC_DIR}
    auth: token
    secretRef:
      name: git-creds
```

Once Config Sync is configured you get retrieve its status using the `nomos status` command.

> Note: External IP redacted from output

  ```console
  Connecting to clusters...
  I0316 10:10:01.991200   15340 request.go:601] Waited for 1.1372862s due to client-side throttling, not priority and   fairness, request: GET:https://x.x.x.x/apis/sourcerepo.cnrm.cloud.google.com/v1beta1?timeout=3s

  *gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster
    --------------------
    UNKNOWN   No RootSync or RepoSync resources found
  ```

#### Implementing Config Sync

> Warning: You can use Option 1 and 2 directly from a clone of this repo, but you will need to use a Git repo of your own for this step.

The following will guide you during the setup of Config Sync.

**Steps**

  > Note: If you previously tried Option 1, make sure that you have deleted the file `resourcegroup.yaml` from the gke-autopilot folder.

1. Copy the services/private-gke/client-experimentation folder to an empty repo or an existing one.

1. Create a git-creds secret.

    You need to create a kubernetes secret that grants "code read" permission.

    > Note: This example will use an Azure Devops Repo. Further info can be found on this site: https://cloud.google.com/anthos-config-management/docs/how-to/installing-config-sync#git-creds-secret.

1. Configure the following environment variables:

    ```
    export GIT_USERNAME=<git username>
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

1. Change the following values inside the `setters.yaml` file:

- project-id
- cluster-name
- cluster-description

Render the configuration files once your values have been set. Starting at the root of this repo run the following:

```sh
cd services/private-gke/client-experimentation/gke-autopilot
kpt fn render
```

1. Push your changes to your repo.

#### Deploy GKE using Config Sync

1. Create a `RootSync` for the GKE Autopilot cluster.

    `root-sync-gke-autopilot.yaml`

    Change the following variables to match your Git Repo config.

    CONFIG_SYNC_REPO
    <br>CONFIG_SYNC_DIR

    ```yaml
    # Root sync for GKE Autopilot Cluster
    apiVersion: configsync.gke.io/v1beta1
    kind: RootSync
    metadata:
      name: root-sync-git-gke-autopilot
      namespace: config-management-system
    spec:
      sourceFormat: unstructured
      override:
      git:
        repo: ${CONFIG_SYNC_REPO}
        branch: main
        dir: ${CONFIG_SYNC_DIR}
        auth: token
        secretRef:
          name: git-creds
    ```

1. Apply the root-sync-gke-autopilot.yaml. This will setup the config sync for the gke deployment. Run `nomos status` to check on the status of the RootSync. You can also refresh the status by polling the status using the `--poll` flag: `nomos status --poll=10s`

    Starting at the root of this repo run the following:

    ```sh
    cd services/private-gke/client-experimentation/root-syncs/
    kubectl apply -f root-sync-gke-autopilot.yaml
    ```

    Keep checking the status using `nomos status` or `nomos status --poll=10s`.

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

1.    To delete entire cluster you can follow these steps.

      > WARNING: If you delete the cluster before the root sync, Config Sync will automatically reconcile and start re-deploying the cluster.

      Starting at the root of this repo run the following:

      ```sh
      cd services/private-gke/client-experimentation/root-syncs
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
