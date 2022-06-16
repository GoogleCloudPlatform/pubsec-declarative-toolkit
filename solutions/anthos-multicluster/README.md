# Anthos Multi-Custer HA With App Demo

## Description
Demo Anthos Multi-Cluster KCC configuration. 

1. Provision Config Controller Cluster
    1. Set environment variables that match your environment
        ```
        CLUSTER=<cluster-name>
        REGION=<supported-region>
        PROJECT_ID=<project-id>
        NETWORK=<vpc-name>
        SUBNET=<subnet-name>
        ORG_ID=<your_org_id>
        BILLING_ID=<your_billing_id>
        ```

    2. Create Project
        ```
        gcloud projects create $PROJECT_ID --name="Config Controller" --labels=type=infrastructure-automation --set-as-default
        ```

    3. Enable Billing
        ```
        gcloud beta billing projects link $PROJECT_ID --billing-account $BILLING_ID
        ```

    4. Set the project ID
        ```
        gcloud config set project $PROJECT_ID
        ```

    5. Enable the required services
        ```
        gcloud services enable krmapihosting.googleapis.com \
            container.googleapis.com \
            cloudresourcemanager.googleapis.com
        ```

    6. Create a network and subnet
        ```
        gcloud compute networks create $NETWORK --subnet-mode=custom
        gcloud compute networks subnets create $SUBNET  \
        --network $NETWORK \
        --range 192.168.0.0/16 \
        --region $REGION
        ```

    7. Create the Config Controller Instance
        ```
        gcloud anthos config controller create $CLUSTER --location $REGION --network $NETWORK --subnet $SUBNET
        ```
        ```
        gcloud anthos config controller get-credentials $CLUSTER  --location $REGION
        kubens config-control
        ```

    8. Assign Permissions to the config connector Service Account.

        ```
        export ORG_ID=$ORG_ID
        export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
            -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"
        gcloud organizations add-iam-policy-binding "${ORG_ID}" \
            --member "serviceAccount:${SA_EMAIL}" \
            --role "roles/resourcemanager.folderAdmin"
        gcloud organizations add-iam-policy-binding "${ORG_ID}" \
            --member "serviceAccount:${SA_EMAIL}" \
            --role "roles/resourcemanager.projectCreator"
        gcloud organizations add-iam-policy-binding "${ORG_ID}" \
            --member "serviceAccount:${SA_EMAIL}" \
            --role "roles/resourcemanager.projectDeleter"
        gcloud organizations add-iam-policy-binding "${ORG_ID}" \
            --member "serviceAccount:${SA_EMAIL}" \
            --role "roles/iam.securityAdmin"
        gcloud organizations add-iam-policy-binding "${ORG_ID}" \
            --member "serviceAccount:${SA_EMAIL}" \
            --role "roles/orgpolicy.policyAdmin"
        gcloud organizations add-iam-policy-binding "${ORG_ID}" \
            --member "serviceAccount:${SA_EMAIL}" \
            --role "roles/serviceusage.serviceUsageConsumer"
        gcloud organizations add-iam-policy-binding "${ORG_ID}" \
            --member "serviceAccount:${SA_EMAIL}" \
            --role "roles/billing.user"    
        ```     
2. Pull Package

    `kpt pkg get git@github.com:GPS-Demos/gcp-ha-dr.git@main gcp-ha`

3. Modify Package

    Infrastructure.
    cd `infra`
    Update `setters.yaml` file with proper values
    Run `kpt fn render`

4. Deploy the Boostrap Services

    `kubectl apply -f bootstrap`

5. Save Project to the newly created Source Control Instance.

    ```
    git add .
    git commit -m "first commit"
    git push
    ```

     Deploy Infrastructure
    - 2 GKE Clusters (NA1, NA2)
    - Anthos
    - Anthos Config Managment
    - MultiCluster Ingress/Service
    - Gateway API
    - Cloud Armor
    - Databases (cloud SQL)
    - Networks
    - Nat
    - Routers
    - Firewalls
    - Source Repo

5. Build and Deploy Application Code
    1. Cloud Build
        - Build and push container to Artifact Registry (regionalized)
        - Golang App build with ko and Kaniko
        - BinAuth
    2. Cloud Deploy
        - Deploy Application to both GKE Environments

## Usage

### Fetch the package
`kpt pkg get git@github.com:cartyc/gke-multicluster-demo.git@main anthos-multicluster`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree anthos-multicluster`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init anthos-multicluster
kpt live apply anthos-multicluster --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
