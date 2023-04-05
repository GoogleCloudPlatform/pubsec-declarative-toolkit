# gcp-resources

The following folder contains a simple example to deploy a GCS bucket.

You can use a Config Controller cluster to provision and orchestrate Anthos and Google Cloud resources.
<br><https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-overview>

You can deploy and manage Google Cloud resources once you have deployed a Config [Controller Cluster](../../../../private-kcc/client-experimentation/). You can use one of the steps below once your cluster is ready to provision and manage your Google Cloud resources.

## Option 1 - Using kubectl

Using the `kubectl` cli:
<br><https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#install_kubectl>

**Steps**

1. Replace `${PROJECT_ID?}` in the [storage bucket](storage-bucket.yaml) resource manifest with your assigned project ID value.

    StorageBucket names must be globally unique. For testing purposes you can use your project ID as the bucket name. Replace `${PROJECT_ID?}`

    ```yaml
    # Creates a storage bucket using client assigned project id
    apiVersion: storage.cnrm.cloud.google.com/v1beta1
    kind: StorageBucket
    metadata:
      annotations:
        cnrm.cloud.google.com/force-destroy: "false"
        # Replace ${PROJECT_ID?} with your assigned project ID.
        cnrm.cloud.google.com/project-id: ${PROJECT_ID?}
      # StorageBucket names must be globally unique. Replace ${PROJECT_ID?} with your assigned project ID.
      name: ${PROJECT_ID?}
    spec:
      storageClass: STANDARD
      location: northamerica-northeast1
      versioning:
        enabled: false
      uniformBucketLevelAccess: true
      publicAccessPrevention: enforced
    ```

1. Run the following command to deploy and configure the Google storage bucket.

    Starting at the root of this repo run the following:

    ```sh
    cd services/private-kcc/client-experimentation/gcp-resources/examples
    kubectl apply -f storage-bucket.yaml
    ```

    > Example status result

    ```console
    storagebucket.storage.cnrm.cloud.google.com/scemu-sp-kcc-exp created
    ```

    > Please monitor the progress via the following command.

    ```sh
    kubectl describe storagebucket.storage.cnrm.cloud.google.com/scemu-sp-kcc-exp
    ```

    > This examples gives us an error.
    <br>
    > This error message has been redacted.

    ```console
      ...Permission 'storage buckets.create' denied on resource (or it may not exist)., forbidden
    ```

1. Fix the permission error by giving the yakima service account the required permission(s). For the sake of this example we will assign the Storage Admin role: `roles/storage.admin`.

    > Replace "${PROJECT_ID}" with your assigned project ID.

    ```sh
    export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
    -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/storage.admin" \
    --project "${PROJECT_ID}"
    ```

1. Verify that the permissions worked and that the storage bucket has been created.

    ```sh
    kubectl describe storagebucket.storage.cnrm.cloud.google.com/scemu-sp-kcc-exp
    ```

    > The status may take a while to clear up, but will show a similar result.

    ```console
    Normal   Updating      4m5s (x13 over 18m)  storagebucket-controller  Update in progress
    Normal   UpToDate      4m4s (x2 over 4m4s)  storagebucket-controller  The resource is up to date
    ```

    The storage bucket has been created.

    > Example result of `gsutil ls` command

    ```console
    gsutil ls
    gs://scemu-sp-kcc-exp/
    ```

1. Deleting the storage bucket resource.

    From krm-resources/deploy/gcp-resources/examples

    ```sh
    kubectl delete -f storage-bucket.yaml
    ```

    > Example result

    ```console
    storagebucket.storage.cnrm.cloud.google.com "scemu-sp-kcc-exp" deleted
    ```

    > Please monitor the progress from the Kubernetes Engine Console or using these commands.

    ```sh
    kubectl get storagebucket.storage.cnrm.cloud.google.com/scemu-sp-kcc-exp
    kubectl describe storagebucket.storage.cnrm.cloud.google.com/scemu-sp-kcc-exp
    ```

    > The following indicates that the resource has been deleted.

    ```console
    Error from server (NotFound): storagebuckets.storage.cnrm.cloud.google.com "scemu-sp-kcc-exp" not found
    Error from server (NotFound): storagebuckets.storage.cnrm.cloud.google.com "scemu-sp-kcc-exp" not found
    ```

## Option 2 - Using Config Sync

Config sync can be used to deploy and manage Google Cloud resources hosted inside a Git repo.

More information can be found here:
<br><https://cloud.google.com/anthos-config-management/docs/config-sync-overview>

The following example will use a single `RootSync` configuration:
<br><https://cloud.google.com/anthos-config-management/docs/how-to/multiple-repositories#manage-root-repos>

This example will use a single `RootSync` [manifest](../../../root-syncs/root-sync-gcp-resources.yaml) file to setup config sync for gcp resources.

Config sync status can be retrieved using the `nomos status` command.

> Note: External IP redacted from output

  ```console
  Connecting to clusters...
  I0316 10:10:01.991200   15340 request.go:601] Waited for 1.1372862s due to client-side throttling, not priority and   fairness, request: GET:https://x.x.x.x/apis/sourcerepo.cnrm.cloud.google.com/v1beta1?timeout=3s

  *gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster
    --------------------
    UNKNOWN   No RootSync or RepoSync resources found
  ```

### Implementing Config Sync

The following will guide you during the setup of Config Sync.

**Steps**

1. Copy the services/private-kcc/client-experimentation/gcp-resources folder into an empty repo or an existing one.

1. Create a git-creds secret.

    You need to create a kubernetes secret that grants "code read" permission.

    > Note: This example will use an Azure Devops Repo. Further info can be found on this site: <https://cloud.google.com/anthos-config-management/docs/how-to/installing-config-sync#git-creds-secret>.

1. Configure the following environment variables:

    ```bash
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

#### Deploy the GCS bucket example using Config Sync

The Config Sync `RootSync` observes a Git repo for resource manifest files `.yaml` and applies them given the specified instructions. When you make a change to your manifest files it's important to push your changes to your repo in order for them to be applied or reconciled.

1. You must place the `storage-bucket.yaml` file inside a repo. This example will use the following path `krm-resources/deploy/gcp-resources/examples/` for the `RootSync`

1. Replace `${PROJECT_ID?}` in the [storage bucket](storage-bucket.yaml) resource manifest with your assigned project ID value.

    StorageBucket names must be globally unique. For testing purposes you can use your project ID as the bucket name. Replace `${PROJECT_ID?}`

    ```yaml
    # Creates a storage bucket using client assigned project id
    apiVersion: storage.cnrm.cloud.google.com/v1beta1
    kind: StorageBucket
    metadata:
      annotations:
        cnrm.cloud.google.com/force-destroy: "false"
        # Replace ${PROJECT_ID?} with your assigned project ID.
        cnrm.cloud.google.com/project-id: ${PROJECT_ID?}
      # StorageBucket names must be globally unique. Replace ${PROJECT_ID?} with your assigned project ID.
      name: ${PROJECT_ID?}
    spec:
      storageClass: STANDARD
      location: northamerica-northeast1
      versioning:
        enabled: false
      uniformBucketLevelAccess: true
      publicAccessPrevention: enforced
    ```

1. Push your changes to your repo.

1. You can create a `RootSync` for Google Cloud resources using the following instructions.

  > This example will use the following path `services/private-kcc/client-experimentation/gcp-resources` for the `RootSync`.
  The `RootSync` config file is excluded from the [folder](../../gcp-resources/examples/) where Config Sync will monitor for any changes.

  ```text
  root-sync-gcp-resources.yaml
  ```

> Change ${GIT_REPO} for the url of your Git repo.

   ```yaml
   # Root sync for GCP resources
   apiVersion: configsync.gke.io/v1beta1
   kind: RootSync
   metadata:
     name: root-sync-git-gcp-resources
     namespace: config-management-system
   spec:
     sourceFormat: unstructured
     override:
     git:
       repo: ${GIT_REPO}
       branch: main
       dir: services/private-kcc/client-experimentation/gcp-resources
       auth: token
       secretRef:
         name: git-creds
   ```

1. Apply the root-sync-gcp-resources.yaml. This will setup the config sync for the gke deployment. Run `nomos status` to check on the status of the RootSync. You can also refresh the status by polling the status using the `--poll` flag: `nomos status --poll=10s`

    Starting at the root of this repo run the following:

    ```sh
    cd krm-resources/root-syncs
    kubectl apply -f root-sync-gcp-resources.yaml
    ```

    Keep checking the status using `nomos status` or `nomos status --poll=10s`.

    > Example output of successful deployment

    ```console
    *gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster
      --------------------
      <root>:root-sync-git-gcp-resources       https://gc-cpa@dev.azure.com/gc-cpa/iac-gcp-dev/_git/gcp-stjeanl1-client-kcc-gke/krm-resources/deploy/gcp-resources@main
      SYNCED @ 2023-03-20 09:45:34 -0400 EDT    5cb4a75e12a2c0b63d17bf55077c47cabd8ee026
      Managed resources:
         NAMESPACE        NAME                                                           STATUS    SOURCEHASH
         config-control   storagebucket.storage.cnrm.cloud.google.com/scemu-sp-kcc-exp   Current   5cb4a75
    ```

1. Your GCS bucket is ready!

#### Destroy your GCS bucket using Config Sync

1. Run these commands to delete the gcs bucket example and RootSync.

    ```sh
    cd krm-resources/root-syncs
    kubectl delete -f root-sync-gcp-resources.yaml
    kubectl delete storagebucket.storage.cnrm.cloud.google.com/scemu-sp-kcc-exp
    ```

    ```console
    rootsync.configsync.gke.io "root-sync-git-gcp-resources" deleted
    storagebucket.storage.cnrm.cloud.google.com "scemu-sp-kcc-exp" deleted
    ```

    `nomos status` and `kubectl get gcp` should return these results.

    ```console
    *gke_scemu-sp-kcc-exp_northamerica-northeast1_krmapihost-kcc-cluster
    --------------------
    UNKNOWN   No RootSync or RepoSync resources found
    ```

    > You will only get this status if no other resources have been deployed using Config Sync.

    ```console
    No resources found in config-control namespace.
    ```
