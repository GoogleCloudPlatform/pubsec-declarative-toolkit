# Deploy Config Controller Cluster - Autopilot

Follow these instructions to deploy an autopilot Config Controller Cluster inside a project.

## bootstrap

**Steps**

1. Get your project-id from Cloud Operations.

1. Authenticate using `gcloud auth login` with your assigned project user credentials.

1. Configure the [environment file](.env) `.env`. This will be used by the [bash script](deploy-kcc-autopilot.sh).

    ```shell
    export CLUSTER_NAME=kcc-cluster
    export REGION=northamerica-northeast1
    export PROJECT_ID=projectid
    export NETWORK=kcc-cluster-vpc
    export SUBNET=kcc-cluster-snet
    ```

    |Variable|Description/Use|
    |--------|---------------|
    | CLUSTER_NAME   | Name of the KCC cluster  |
    | REGION | The region where to deploy the KCC cluster |
    | PROJECT_ID | The `project_id` where to deploy the KCC cluster.   |
    | NETWORK  | The name of the VPC network that will be created  |
    | SUBNET | The name of the subnet that will be deployed inside the VPC network |

1. Execute the deployment script, specifying the environment file `.env`:

    > **Note:** Run this command starting at the root of this repo:

    ```shell
    cd services/private-kcc/client-experimentation/kcc-autopilot
    bash deploy-kcc-autopilot.sh .env
    ```

## Destroy and Cleanup

> Running the destroy script will destroy the KCC Cluster including all of the components and services that were deployed by the `deploy-kcc-autopilot.sh` script.

1. Execute the destroy script, specifying the environment file `.env`:

    > **Note:** Run this command starting at the root of this repo:

    ```shell
    cd services/private-kcc/client-experimentation/kcc-autopilot
    bash destroy-kcc-autopilot.sh .env
    ```
