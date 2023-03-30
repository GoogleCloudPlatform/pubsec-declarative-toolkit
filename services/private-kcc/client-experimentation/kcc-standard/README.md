# Deploy Config Controller Cluster - Standard

Follow these instructions to deploy a Standard Config Controller Cluster inside a project. 

## bootstrap

**Steps**

1. Get your project-id from Cloud Operations

1. Configure the [environment file](.env) `.env`. This will be used by the [bash script](deploy-kcc-standard.sh).

    ```sh
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

- Execute the deployment script, specifying the environment file `.env`:

    > **Note:** Run this command starting at the root of this repo:

    ```sh
    cd services/private-kcc/client-experimentation/kcc-standard
    bash deploy-kcc-standard.sh .env
    ```

## Destroy and Cleanup

1. Execute the destroy script, specifying the environment file `.env`:

    > **Note:** Run this command starting at the root of this repo:

    ```sh
    cd services/private-kcc/client-experimentation/kcc-standard
    bash destroy-kcc-standard.sh .env
    ```