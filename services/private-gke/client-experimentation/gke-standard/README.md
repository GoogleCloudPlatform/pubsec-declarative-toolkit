# Deploy Standard GKE Cluster

These instructions will help you deploy a GKE Standard Cluster inside your project.

> Pre-requisite: You must deploy an [autopilot](../../../private-kcc/client-experimentation/kcc-autopilot/deploy-kcc-autopilot.sh) or [standard](../../../private-kcc/client-experimentation/kcc-standard/deploy-kcc-standard.sh) Config Controller cluster before proceeding. Certain IAM permissions are applied using these scripts to give the yakima service account permissions to deploy the GKE required resources and clusters.

## Deployment Options

> Important: Please make sure to edit the [setters.yaml](setters.yaml) file as it contains important variables.

> The following steps require the kpt cli:
> <br>https://kpt.dev/installation/kpt-cli

To quickly get started, update the following values inside the `setters.yaml` file:

- project-id
- cluster-name
- cluster-description

Render the configuration files once your values have been set. Starting at the root of this repo run the following:

```sh
cd services/private-gke/client-experimentation/gke-standard
kpt fn render
```

> Results should look like this:

```console
Package "gke":
[RUNNING] "gcr.io/kpt-fn/apply-setters:v0.2"
[PASS] "gcr.io/kpt-fn/apply-setters:v0.2" in 700ms
  Results:
    [info] metadata.name: set field value to "ssc-spc-exp-cluster1"
    [info] metadata.namespace: set field value to "config-control"
    [info] metadata.labels.cluster: set field value to "ssc-spc-exp-cluster1"
    [info] metadata.annotations.cnrm.cloud.google.com/project-id: set field value to "scemu-sp-kcc-exp"
    ...(14 line(s) truncated, use '--truncate-output=false' to disable)

Successfully executed 1 function(s) in 1 package(s).
```

You are now ready to deploy the GKE Standard cluster using any of the following options.

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
    cd services/private-gke/client-experimentation/gke-standard
    kpt live init
    ```

    > Expected output

    ```console
    initializing "resourcegroup.yaml" data (namespace: config-control)...success
    ```

1. From this folder execute the apply command to deploy the GKE cluster and worker node pool.

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
    containercluster.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1 apply successful
    apply phase finished
    reconcile phase started
    configmap/setters reconcile successful
    containercluster.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1 reconcile pending
    containercluster.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1 reconcile successful
    reconcile phase finished
    apply phase started
    containernodepool.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1-wp-1 apply successful
    apply phase finished
    reconcile phase started
    containernodepool.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1-wp-1 reconcile pending
    containernodepool.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1-wp-1 reconcile successful
    reconcile phase finished
    inventory update started
    inventory update finished
    apply result: 3 attempted, 3 successful, 0 skipped, 0 failed
    reconcile result: 3 attempted, 3 successful, 0 skipped, 0 failed, 0 timed out
    ```

1.  Your GKE cluster is now ready! Connect using the following command. Please change the following values: `cluster-name`, `location`, and `project-id`.

    ```bash
    gcloud container clusters get-credentials cluster-name --region location --project project-id
    ```

> Deletion instructions<br>
> These instructions does not delete the Config Controller cluster.

1. You will need to switch to the KCC cluster context in order to destroy your GKE cluser.

    Retrieve the list of contexts.

    ```bash
    kubectl config get-contexts
    ```

    Copy the value of the KCC cluster under the CLUSTER column and run the following command using the copied value.

    Example:

    ```bash
    kubectl config use-context gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster
    ```

    > Example result:

    ```console
    Switched to context "gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster".
    ```

1. Run this command inside `services/private-gke/client-experimentation/gke-standard` to destroy your GKE cluster.

    ```sh
    kpt live destroy
    ```

    > This step will take 5 minutes or more to complete. Please monitor the output on the console as this command is live.

    > Example status result

    ```console
    delete phase started
    containernodepool.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1-wp-1 delete successful
    delete phase finished
    reconcile phase started
    containernodepool.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1-wp-1 reconcile pending
    containernodepool.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1-wp-1 reconcile successful
    reconcile phase finished
    delete phase started
    containercluster.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1 delete successful
    configmap/setters delete successful
    delete phase finished
    reconcile phase started
    containercluster.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1 reconcile pending
    configmap/setters reconcile pending
    configmap/setters reconcile successful
    containercluster.container.cnrm.cloud.google.com/ssc-spc-exp-cluster1 reconcile successful
    reconcile phase finished
    inventory update started
    inventory update finished
    delete result: 3 attempted, 3 successful, 0 skipped, 0 failed
    reconcile result: 3 attempted, 3 successful, 0 skipped, 0 failed, 0 timed out
    ```

1.  Your GKE cluster is now deleted!

1. Manaually delete the file `resourcegroup.yaml` from the `gke-standard` folder.

    ```sh
    rm resourcegroup.yaml
    ```

### Option 2 - Using kubectl

Using the `kubectl` cli:
<br>https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#install_kubectl

**Steps**

  > Note: If you previously tried Option 1, make sure that you have deleted the file `resourcegroup.yaml` from the `gke-standard` folder.

To quickly get started, change the following value inside the `setters.yaml` file:

- project-id
- cluster-name
- cluster-description

Render the configuration files once your values have been set. Starting at the root of this repo run the following:

```sh
cd services/private-gke/client-experimentation/gke-standard
kpt fn render
```

1. Run the following command inside the `services/private-gke/client-experimentation/gke-standard` folder to deploy the GKE Standard Cluster and Node Pool.

    ```sh
    cd ..
    kubectl apply -f .
    ```

    > This step will take 5 minutes or more to complete.

    > Example status result

    ```console
    containercluster.container.cnrm.cloud.google.com/exp-cluster created
    containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1 created
    configmap "setters" created
    ```

    > Please monitor the progress from the Kubernetes Engine Console or via the following commands.

    ```sh
    kubectl get gcp -A
    ```

1. Run the following command inside the `services/private-gke/client-experimentation/gke-standard` folder to delete the GKE Standard Cluster and Node Pool.

    > These instructions does not delete the Config Controller cluster.

    ```sh
    kubectl delete -f .
    ```

    > This step will take 5 minutes or more to complete.

    > Example status result

    ```console
    containercluster.container.cnrm.cloud.google.com "exp-cluster" deleted
    containernodepool.container.cnrm.cloud.google.com "exp-cluster-wp-1" deleted
    configmap "setters" deleted
    ```

    > Please monitor the progress from the Kubernetes Engine Console or wait until this command completes.

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

This example will use a [RootSync](../root-syncs/root-sync-gke-standard.yaml).

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

1. Install the `nomos` tool.

    ```bash
    gcloud components install nomos
    ```

    For information on alternate ways to install the nomos tool, see [Anthos Config Management downloads](https://cloud.google.com/anthos-config-management/downloads#nomos_command).

1. Copy the services/private-gke/client-experimentation/gke-standard folder into an empty repo or an existing one.

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

1. Update the following values inside the `setters.yaml` file:

- project-id
- cluster-name
- cluster-description

Render the configuration files once your values have been set. Starting at the root of this repo run the following:

```sh
cd services/private-gke/client-experimentation/gke-autopilot
kpt fn render
```

#### Deploy GKE using Config Sync

1. Create a `RootSync` for the GKE Standard cluster.

    `root-sync-gke-standard.yaml`

    Change the following variables to match your Git Repo config.

    > The CONFIG_SYNC_DIR variable should be similar to services/private-gke/client-experimentation/gke-autopilot or services/private-gke/client-experimentation/.

    CONFIG_SYNC_REPO
    <br>CONFIG_SYNC_DIR

    ```yaml
    # Root sync for GKE Standard Cluster
    apiVersion: configsync.gke.io/v1beta1
    kind: RootSync
    metadata:
      name: root-sync-git-gke-standard
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

1. Apply the root-sync-gke-standard.yaml. This will setup the config sync for the gke deployment. Run `nomos status` to check on the status of the RootSync. You can also refresh the status by polling the status using the `--poll` flag: `nomos status --poll=10s`

    ```sh
    kubectl apply -f root-sync-gke-standard.yaml
    ```

    Keep checking the status using `nomos status` or `nomos status --poll=10s`.

    > Example output during deployment

    ```console
    *gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster-auto
      --------------------
      <root>:root-sync-git-gke-standard        https://gc-cpa@dev.azure.com/gc-cpa/iac-gcp-dev/_git/gcp-stjeanl1-client-kcc-gke/services/private-gke/_testing/   gke-standard@main
      SYNCED @ 2023-03-22 12:47:20 -0400 EDT   092079e986fb0c1dfe67a8ebd2c407aa3f7b7e18
      Managed resources:
         NAMESPACE            NAME                                                                          STATUS    SOURCEHASH
         config-control   containercluster.container.cnrm.cloud.google.com/   exp-cluster              Current   092079e
         config-control   containernodepool.container.cnrm.cloud.google.com/    exp-cluster-wp-1        Current   092079e
            Update in progress
         default   configmap/setters   Current   092079e
    ```

    > Example output of successful deployment

    ```console
    *gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster-auto
      --------------------
      <root>:root-sync-git-gke-standard        https://gc-cpa@dev.azure.com/gc-cpa/iac-gcp-dev/_git/gcp-stjeanl1-client-kcc-gke/services/private-gke/_testing/gke-standard@main
      SYNCED @ 2023-03-22 12:47:20 -0400 EDT      092079e986fb0c1dfe67a8ebd2c407aa3f7b7e18
      Managed resources:
         NAMESPACE        NAME                                                                      STATUS    SOURCEHASH
         config-control   containercluster.container.cnrm.cloud.google.com/exp-cluster              Current   092079e
         config-control   containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1        Current   092079e
         default          configmap/setters                                                         Current   092079e
    ```

1.  Your GKE cluster is now ready! Connect using the following command. Please change the following values: `cluster-name`, `location`, and `project-id`.

    ```bash
    gcloud container clusters get-credentials cluster-name --region location --project project-id
    ```

#### Destroy your GKE Cluster using Config Sync

> These instructions does not delete the Config Controller cluster.

1.    To delete entire cluster and node pool you can follow these steps.

      Starting at the root of this repo run the following:

      > WARNING: If you delete the cluster and node pool before the root sync, Config Sync will automatically reconcile and start re-deploying the cluster and node pool.

      ```sh
      kubectl delete -f root-sync-gke-standard.yaml
      kubectl delete containercluster.container.cnrm.cloud.google.com/exp-cluster
      kubectl delete containernodepool.container.cnrm.cloud.google.com/exp-cluster-wp-1
      ```
      > Expected result

      ```console
      rootsync.configsync.gke.io "root-sync-git-gke-standard" deleted
      containercluster.container.cnrm.cloud.google.com "exp-cluster" deleted
      containernodepool.container.cnrm.cloud.google.com "exp-cluster-wp-1" deleted
      ```
