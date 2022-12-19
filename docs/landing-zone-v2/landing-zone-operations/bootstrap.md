# Bootstrap procedure
## Summary
This step-by-step procedure deploys :
  - A GCP folder to host the landing zone hierarchy.
  - A config controller project.
  - A VPC, a subnet and a Cloud NAT.
  - Private Service Connect to access googleapis.com and gcr.io
  - VPC firewall rules.
  - A config controller cluster.
  - IAM permission for the "Yakima" service account.
  - The K8S secret to access the repository.
  - The initial root-sync.yaml.
  - Grant billing user role to projects-sa service account.

## Requirements
1. Cloud identity has been deployed
1. GCP IAM persmissions for the account executing this procedure:
   - Org level:
      - Organization Admin
      - Folder Admin
      - Project Admin
      - Compute Network Admin
      - Service Directory Editor
      - DNS Administrator
    - Billing account:
      - Billing admin
1. Software
    * [Google Cloud SDK version >= 325.0.0](https://cloud.google.com/sdk/docs/downloads-versioned-archives)
    * [kpt](https://kpt.dev/installation/)
    * [kubectl](https://kubernetes.io/docs/tasks/tools/) ( >= v1.20)
1. Create and populate configsync and infra repo
    - Procedure in `building.md` have been executed
    - Make sure to copy the `.env` and `root-sync.yaml` files into the `<infra repo>`/bootstrap/`<env>`

## Process
1. Define environment variables
    ```
    CLUSTER=<cluster-name>
    REGION=northamerica-northeast1
    PROJECT_ID=<project-id>
    LZ_FOLDER_NAME=<env>-<landing zone name>
    NETWORK=<vpc-name>
    SUBNET=<subnet-name>
    ORG_ID=<your_org_id>
    ROOT_FOLDER_ID=<your_folder_id> # This one is only required if not deploying at the org level. See option 2 below. (ex. for testing)
    BILLING_ID=XXXXX-XXXXX-XXXXX
    GIT_USERNAME=<git username> # For Azure Devops, this is the name of the Organization
    TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    ```
1. Create LZ folder
    ### Option 1 - Org level folder
    ```
    FOLDER_ID=$(gcloud resource-manager folders create --display-name=$LZ_FOLDER_NAME --organization=$ORG_ID --format="value(name)" --quiet | cut -d "/" -f 2)
    ```
    ### Option 2 - Folder in a Folder
    ```
    FOLDER_ID=$(gcloud resource-manager folders create --display-name=$LZ_FOLDER_NAME  --folder=$ROOT_FOLDER_ID --format="value(name)" --quiet | cut -d "/" -f 2)
    ```
1. Create config controller project
    ### Option 1 - Org level Project
    ```
    gcloud projects create $PROJECT_ID --set-as-default --organization=$ORG_ID
    ```
    ### Option 2 - Project in a Folder
    ```
    gcloud projects create $PROJECT_ID --set-as-default --folder=$ROOT_FOLDER_ID
    ```
1. Enable Billing
    ```
    gcloud beta billing projects link $PROJECT_ID --billing-account $BILLING_ID 
    ```
1. Set the project ID
    ```
    gcloud config set project $PROJECT_ID
    ```
1. Enable the required services
    ```
    gcloud services enable krmapihosting.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com cloudbilling.googleapis.com serviceusage.googleapis.com servicedirectory.googleapis.com dns.googleapis.com
    ```

1. Create network
    ```
    gcloud compute networks create $NETWORK --subnet-mode=custom

    gcloud compute networks subnets create $SUBNET  \
    --network $NETWORK \
    --range 192.168.0.0/16 \
    --region $REGION \
    --stack-type=IPV4_ONLY \
    --enable-private-ip-google-access \
    --enable-flow-logs --logging-aggregation-interval=interval-5-sec --logging-flow-sampling=1.0 --logging-metadata=include-all

    # Cloud router and Cloud NAT
    gcloud compute routers create kcc-router --project=$PROJECT_ID  --network=$NETWORK  --asn=64513 --region=$REGION
    gcloud compute routers nats create kcc-router --router=kcc-router --region=$REGION --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges --enable-logging
    ```

1.  Private Service Connect to access Google's API
    ```
    # enable logging for dns 
    gcloud dns policies create dnspolicy1 \
    --networks=$NETWORK \
    --enable-logging \
    --description="dns policy to enable logging"

    # private ip for apis
    gcloud compute addresses create apis-private-ip \
    --global \
    --purpose=PRIVATE_SERVICE_CONNECT \
    --addresses=10.255.255.254 \
    --network=$NETWORK

    # private endpoint
    gcloud compute forwarding-rules create endpoint1 \
    --global \
    --network=$NETWORK \
    --address=apis-private-ip \
    --target-google-apis-bundle=all-apis \
    --service-directory-registration=projects/$PROJECT_ID/locations/$REGION

    # private dns zone for googleapis.com
    gcloud dns managed-zones create googleapis \
    --description="dns zone for googleapis" \
    --dns-name=googleapis.com \
    --networks=$NETWORK \
    --visibility=private

    gcloud dns record-sets create googleapis.com. --zone="googleapis" --type="A" --ttl="300" --rrdatas="10.255.255.254"

    gcloud dns record-sets create *.googleapis.com. --zone="googleapis" --type="CNAME" --ttl="300" --rrdatas="googleapis.com."

    # private dns zone for gcr.io
    gcloud dns managed-zones create gcrio \
    --description="dns zone for gcrio" \
    --dns-name=gcr.io \
    --networks=$NETWORK \
    --visibility=private

    gcloud dns record-sets create gcr.io. --zone="gcrio" --type="A" --ttl="300" --rrdatas="10.255.255.254"

    gcloud dns record-sets create *.gcr.io. --zone="gcrio" --type="CNAME" --ttl="300" --rrdatas="gcr.io."
    ```

1. Create firewall rules
    ```
    # Allow egress to AZDO (optionnal)
    gcloud compute firewall-rules create allow-egress-azure --action ALLOW --rules tcp:22,tcp:443 --destination-ranges 13.107.6.0/24,13.107.9.0/24,13.107.42.0/24,13.107.43.0/24 --direction EGRESS --priority 5000 --network $NETWORK --enable-logging

    # Allow egress to internal, peered vpc and secondary ranges
    gcloud compute firewall-rules create allow-egress-internal --action ALLOW --rules=all --destination-ranges 192.168.0.0/16,172.16.0.128/28,10.0.0.0/8 --direction EGRESS --priority 1000 --network $NETWORK --enable-logging
     
    # Deny egress to internet
    gcloud compute firewall-rules create deny-egress-internet --action DENY --rules=all --destination-ranges 0.0.0.0/0 --direction EGRESS --priority 65535 --network $NETWORK --enable-logging
    ```

1. Create anthos config controller cluster
    ### GKE Autopilot - Fully managed cluster
    TODO: TBD

    ### GKE Standard
    ```
    gcloud anthos config controller create $CLUSTER --location $REGION --network $NETWORK --subnet $SUBNET 
    ```
1. Get Credentials
    ```
    gcloud anthos config controller get-credentials $CLUSTER  --location $REGION
    kubens config-control
    ```
1. Set permissions for "Yakima" (Google managed) service account
    ```
    gcloud anthos config controller get-credentials $CLUSTER --location $REGION 

    export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
        -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

    gcloud organizations add-iam-policy-binding "${ORG_ID}" \
      --member="serviceAccount:${SA_EMAIL}" \
      --role=roles/resourcemanager.organizationAdmin \
      --condition=None
      
    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
      --member "serviceAccount:${SA_EMAIL}" \
      --role "roles/editor" \
      --project "${PROJECT_ID}"

    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
      --member "serviceAccount:${SA_EMAIL}" \
      --role "roles/iam.serviceAccountAdmin" \
      --project "${PROJECT_ID}"
    ```

1. Create `git-creds` secret
    ```
    kubectl create secret generic git-creds --namespace="config-management-system" --from-literal=username=${GIT_USERNAME} --from-literal=token=${TOKEN}
    ```

1. Deploy `root-sync.yaml`
    ```
    kubectl apply -f root-sync.yaml
    ```

1. Validate deployment
    ```
    nomos status --contexts gke_${PROJECT_ID}_northamerica-northeast1_krmapihost-${CLUSTER}
    ```

1. **WAIT** until the GCP Service Account `projects-sa` has been created. 
    - K8S resource name is `iamserviceaccount.iam.cnrm.cloud.google.com/projects-sa`

1. Grant billing account user role to projects-sa (repeat this step on all billing account used in the landing zone)
    ```
    gcloud beta billing accounts add-iam-policy-binding "${BILLING_ID}" \
      --member "serviceAccount:projects-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
      --role "roles/billing.user"
    ```


## TODO: FUTURE IMPROVEMENTS - ** TO BE VETTED - DO NOT RUN!!!!!**
### logging
```
gcloud alpha logging settings update --organization=$ORG_ID --storage-location=$REGION -->
```
