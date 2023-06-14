# Deploy a Guardrails Environment using the Anthos Config Management

## Getting Started

Our first step will be to provision a Config Controller Instance to deploy our infrastructure with.

To do that follow the steps outlined in the advanced [install guide](../docs/advanced-install.md). This process should take about 20mins or if you have  `arete` installed you can run the following command.

```shell
arete create my-configcontroller --region northamerica-northeast1 --project=my-project-id
```

We will be adding some org level services so we will need to update the permissions on the Config Controller Service Account.

First lets set some environment variables.

```shell
export ORG_ID=<orgID>
export PROJECT_ID=<config-controller-project-id>
export CONFIG_CONTROLLER_NAME=<name-of-config-controller-instance>
```

```shell
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
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/iam.serviceAccountAdmin"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/serviceusage.serviceUsageAdmin"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/source.admin"
```

This will create a new Config Controller instance along with networking in the target project.

## Setting Up ACM

Now that we have a Config Controller Instance up we'll want to create a Source Repository for us to store our infrastructure code in. For this example we will be using Cloud Source Repositories because we can quickly create it and access it using Workload Identity, so no keys to manage! If you already have a favorite source repository you should be able to use that following these [instructions](https://cloud.google.com/anthos-config-management/docs/how-to/installing-config-sync#git-creds-secret).

The following steps are modified from this [guide](https://cloud.google.com/anthos-config-management/docs/how-to/config-controller-setup#manage-resources)

1. Enable source repository service.

```shell
cat > service.yaml << EOF
apiVersion: serviceusage.cnrm.cloud.google.com/v1beta1
kind: Service
metadata:
  name: sourcerepo.googleapis.com
  namespace: config-control
EOF
```

2. Apply the manifest

```shell
kubectl apply -f service.yaml
```

This should take a few minutes for the service to enable. You can check on it's status or watch it deploy by running `kubectl wait -f service.yaml --for=condition=Ready`

3. Create the Repository Configs

```shell
cat > repo.yaml << EOF

apiVersion: sourcerepo.cnrm.cloud.google.com/v1beta1
kind: SourceRepoRepository
metadata:
  name: guardrails-configs
  namespace: config-control
EOF
```

4. Create the repository

```shell
kubectl apply -f repo.yaml
```

Now we have our base infrastructure in place and we can now set up some IAM so the ACM instance we will create can access the Source Repo.

5. Create the IAM permissions. This is grant source repository reader access to the ACM service account.

```shell
cat > gitops-iam.yaml << EOF
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMServiceAccount
metadata:
  name: config-sync-sa
  namespace: config-control
spec:
  displayName: ConfigSync

---

apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: config-sync-wi
  namespace: config-control
spec:
  member: serviceAccount:${PROJECT_ID}.svc.id.goog[config-management-system/root-reconciler]
  role: roles/iam.workloadIdentityUser
  resourceRef:
    apiVersion: iam.cnrm.cloud.google.com/v1beta1
    kind: IAMServiceAccount
    name: config-sync-sa

---

apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: allow-configsync-sa-read-csr
  namespace: config-control
spec:
  member: serviceAccount:config-sync-sa@${PROJECT_ID}.iam.gserviceaccount.com
  role: roles/source.reader
  resourceRef:
    apiVersion: resourcemanager.cnrm.cloud.google.com/v1beta1
    kind: Project
    external: projects/${PROJECT_ID}
EOF
```

6. Apply the configs

```shell
kubectl apply -f gitops-iam.yaml
```

7. Configure the ACM instance.

```shell
cat > config-management.yaml << EOF

apiVersion: configmanagement.gke.io/v1
kind: ConfigManagement
metadata:
  name: config-management
spec:
  enableMultiRepo: true
  enableLegacyFields: true
  policyController:
    enabled: true
  clusterName: krmapihost-${CONFIG_CONTROLLER_NAME}
  git:
    policyDir: configs
    secretType: gcpserviceaccount
    gcpServiceAccountEmail: config-sync-sa@${PROJECT_ID}.iam.gserviceaccount.com
    syncBranch: main
    syncRepo: https://source.developers.google.com/p/${PROJECT_ID}/r/guardrails-configs
  sourceFormat: unstructured
EOF
```

8. Deploy ACM

```shell
kubectl apply -f config-management.yaml
```

This will take a few minutes to deploy and while we wait for that we'll get the guardrails configuration up and running.

## Guardrails installation

1. Get Guardrails Package.

```shell
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails guardrails
```

This will pull down the configurations required to deploy the guardrails infrastructure.

2. Our next step will be to populate the setters file with any relevant information.

Open the `setters.yaml` file in your favorite text editor. The most important fields here are at the top of the file.

3. Populate the config files with the setters information.

```shell
kpt fn render guardrails
```

```shell
# Successful Output
Package "guardrails-configs/configs/hierarchy":
[RUNNING] "gcr.io/kpt-fn/generate-folders:v0.1"
[PASS] "gcr.io/kpt-fn/generate-folders:v0.1" in 1.2s

Package "guardrails-configs":
[RUNNING] "gcr.io/kpt-fn/apply-setters:v0.2"
[PASS] "gcr.io/kpt-fn/apply-setters:v0.2" in 900ms
  Results:
    [info] metadata.namespace: set field value to "config-control"
    [info] spec.parentRef.external: set field value to "00000000000"
    [info] metadata.namespace: set field value to "config-control"
    [info] metadata.annotations.cnrm.cloud.google.com/organization-id: set field value to "00000000000"
    ...(163 line(s) truncated, use '--truncate-output=false' to disable)
[RUNNING] "gcr.io/kpt-fn/enable-gcp-services:v0.1.0"
[PASS] "gcr.io/kpt-fn/enable-gcp-services:v0.1.0" in 1.8s
  Results:
    [info] serviceusage.cnrm.cloud.google.com/v1beta1/Service/config-control/guardrails-project-services-bigquery: recreated service
    [info] serviceusage.cnrm.cloud.google.com/v1beta1/Service/config-control/guardrails-project-services-cloudasset: recreated service
    [info] serviceusage.cnrm.cloud.google.com/v1beta1/Service/config-control/guardrails-project-services-pubsub: recreated service
[RUNNING] "gcr.io/kpt-fn/kubeval:v0.2"
[PASS] "gcr.io/kpt-fn/kubeval:v0.2" in 4s

Successfully executed 4 function(s) in 2 package(s).
```

This will populate the required fields with the information you set in `setters.yaml`

### Note on Billing ID

If you want to omit the billing id you can leave it as is and in the `configs/project/guardrails/project.yaml` file comment out or delete the billing id section like so.

```yaml
  # billingAccountRef:
  #   # Replace "${BILLING_ACCOUNT_ID?}" with the numeric ID for your billing account
  #   external: "0000000000000" # kpt-set: ${billing-id}
```

This will cause the project to be created without a billing id but you can manually add it in the billing UI under projects or by running the following command `gcloud beta billing projects link $PROJECT_ID --billing-account $BILLING_ID`.

4. Clone the repo that you created in the previous steps.

```shell
gcloud source repos clone guardrails-configs
```

```shell
mv guardrails/* guardrails-configs
rm -rf guardrails
```

```shell
cd guardrails-configs
```

Create and switch to `main` branch.

```shell
git checkout -b main
```

5. Commit your changes to git and push the configs to the repository.

```shell
git add .
git commit -m "Add Guardrails solution"
git push --set-upstream origin main
```

After a few minutes you should start to see the resources deploying into the Config Controller instance

```shell
kubectl get gcp -n config-control
```

The output should resemble this.

```plaintext
NAME                                                                    AGE   READY   STATUS     STATUS AGE
bigquerydataset.bigquery.cnrm.cloud.google.com/bigquerylogginglogsink   18m   True    UpToDate   16m

NAME                                                      AGE   READY   STATUS     STATUS AGE
iamauditconfig.iam.cnrm.cloud.google.com/org-audit-logs   18m   True    UpToDate   17m

NAME                                                                                           AGE   READY   STATUS     STATUS AGE
iampartialpolicy.iam.cnrm.cloud.google.com/grd-rails-test-43535-sa-workload-identity-binding   60m   True    UpToDate   60m

NAME                                                               AGE   READY   STATUS     STATUS AGE
iamserviceaccount.iam.cnrm.cloud.google.com/config-sync-sa         69m   True    UpToDate   69m
iamserviceaccount.iam.cnrm.cloud.google.com/grd-rails-test-43535   60m   True    UpToDate   60m
```

If there are any services that are reporting `UpdateFailed` you can inspect them like a standard Kubernetes object to find out what went wrong or is causing the problem.

For example if you forgot to add the organization policy to the `setters.yaml` file and attempt to deploy the services you should end up in a similar state to this.

```plaintext
NAME                                                                              AGE     READY   STATUS         STATUS AGE
iampolicymember.iam.cnrm.cloud.google.com/allow-configsync-sa-read-csr            17m     True    UpToDate       17m
iampolicymember.iam.cnrm.cloud.google.com/config-sync-wi                          17m     True    UpToDate       17m
iampolicymember.iam.cnrm.cloud.google.com/my-awesome-project-org-policyadmin    9m28s   False   UpdateFailed   9m28s
iampolicymember.iam.cnrm.cloud.google.com/my-awesome-project-sa-logging-admin   9m28s   False   UpdateFailed   9m27s
iampolicymember.iam.cnrm.cloud.google.com/project-id-sa-role-admin                9m28s   False   UpdateFailed   9m27s
```

We can see that they objects are failing so lets use `kubectl describe` to find out what is wrong.

```shell
kubectl describe iampolicymember.iam.cnrm.cloud.google.com/my-awesome-project-org-policyadmin
```

At the bottom of the page you see an events section that contains an explanation for why the object is in it's current state.

```plaintext
Events:
  Type     Reason        Age                 From                        Message
  ----     ------        ----                ----                        -------
  Warning  UpdateFailed  99s (x12 over 13m)  iampolicymember-controller  Update call failed: error fetching live state for resource: error reading underlying resource: summary: Error when reading or editing Resource "organization \"0000000000\"" with IAM Member: Role "roles/orgpolicy.policyAdmin" Member "serviceAccount:service-000000000@gcp-sa-yakima.iam.gserviceaccount.com": Error retrieving IAM policy for organization "0000000000": googleapi: Error 403: The caller does not have permission, forbidden
```

As you can image `0000000000` does not exist so I will have to fix that and rerun `kpt fn render` and save things to get again.

**Note: [Apply Time Mutation](https://kpt.dev/reference/annotations/apply-time-mutation/) is not fully integrated into ACM at the moment so you may see some errors in the ACM logs failing to sync as a result of this.

## Policy Enforcement

Now that we are able to deploy our infrastructure the next thing we might want to do is enforce policy to ensure we're doing things in a compliant manner. Luckily we can do this with [Policy Controller](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller) which is included in Anthos Config Management and preinstalled in our Config Controller instance. Policy Controller allows us to write custom policy as code and have it enforced within our Config Controller instance.

To get you started you can use the policies from our [guardrails-policies](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/guardrails-policies) package. At the time of this writing includes 3 policies (data-location, network-security-services, cloud-marketplace) to help enforce 30 Guardrails policies.

Using the infrastructure we've already deployed we'll download the `guardrails-policy` package and do some local testing.

First move into the `guardrails-configs` folder

```shell
cd guardrails-configs
```

and then grab the package.

```shell
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails-policies configs/guardrails-policies
```

Now we'll need to add the [gatekeeper](https://catalog.kpt.dev/gatekeeper/v0.2/) function to our `Kptfile` (`guardrails-configs/Kptfile`) so that it will execute on a `kpt fn render`. To do that add the following to the `validators` section.

```shell
  validators:
    - image: gcr.io/kpt-fn/kubeval:v0.2
      configMap:
        ignore_missing_schemas: "true"
        strict: "true"
    - image: gcr.io/kpt-fn/gatekeeper:v0.2.1
```

With that added and the file saved running `kpt fn render` should pass. Here's the abbreviated output.

```plaintext
...
[RUNNING] "gcr.io/kpt-fn/kubeval:v0.2"
[PASS] "gcr.io/kpt-fn/kubeval:v0.2" in 5.4s
[RUNNING] "gcr.io/kpt-fn/gatekeeper:v0.2.1"
[PASS] "gcr.io/kpt-fn/gatekeeper:v0.2.1" in 1.8s
```

Now let's modify some files so that we get a failure to show how this works. Open the following file in your favorite code editor `configs/guardrails-policies/05-data-location/constraint.yaml`

This is the file that you will pass in parameters to decide what regions are allowed or not allowed in your environment and should look like the following.

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: DataLocation
metadata: # kpt-merge: /datalocation
  name: datalocation
spec:
  match:
    kinds:
      - apiGroups: ["*"]
        kinds: ["*"]
  parameters:
    locations:
      - "northamerica-northeast1"
      - "northamerica-northeast2"
      - "global"
    allowedServices:
      - ""
```

What this policy is doing is looking for any location that does not belong in the listed locations. In order to trigger a failure remove the following lines and save the file.

```yaml
- "northamerica-northeast1"
- "northamerica-northeast2"
```

Now this policy will only allow global resources to be deployed. Run `kpt fn render` again and things should now fail and you should get output similar to this.

```plaintext
[FAIL] "gcr.io/kpt-fn/gatekeeper:v0.2.1" in 1.6s
  Results:
    [error] bigquery.cnrm.cloud.google.com/v1beta1/BigQueryDataset/config-control/bigquerylogginglogsink: Guardrail # 5: Resource BigQueryDataset ('bigquerylogginglogsink') is located in 'northamerica-northeast1' when it is required to be in '["global"]' violatedConstraint: datalocation
    [error] storage.cnrm.cloud.google.com/v1beta1/StorageBucket/config-control/1020902403876-logginglogsink-erg: Guardrail # 5: Resource StorageBucket ('1020902403876-logginglogsink-erg') is located in 'northamerica-northeast1' when it is required to be in '["global"]' violatedConstraint: datalocation
  Stderr:
    "[error] bigquery.cnrm.cloud.google.com/v1beta1/BigQueryDataset/config-control/bigquerylogginglogsink : Guardrail # 5: Resource BigQueryDataset ('bigquerylogginglogsink') is located in 'northamerica-northeast1' when it is required to be in '[\"global\"]'"
    "violatedConstraint: datalocation"
    ""
    "[error] storage.cnrm.cloud.google.com/v1beta1/StorageBucket/config-control/1020902403876-logginglogsink-erg : Guardrail # 5: Resource StorageBucket ('1020902403876-logginglogsink-erg') is located in 'northamerica-northeast1' when it is required to be in '[\"global\"]'"
    ...(1 line(s) truncated, use '--truncate-output=false' to disable)
```

Now that we've seen what a failure scenario looks like lets revert that change to its working state by re-adding the 2 lines we deleted and committing the new state to git.

```shell
git add .
git commit -m "added guardrails"
git push
```

What will happen now is the policies we just used to validate our infrastructure will be deployed into our cluster. This now means that not only will we get a check locally or in a CI/CD pipeline that our infrastructure state is compliant but it will also be enforced in our cluster. If anyone were to attempt to deploy some new infrastructure to our cluster it would be stopped and the new infra would be denied.

You can check on your policies by using running

```shell
kubectl get constraints
```

Which will return a list of all the running constraints in your cluster

```plaintext
NAME                                                              ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
limitegresstraffic.constraints.gatekeeper.sh/limitegresstraffic                        0

NAME                                                                      ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
cloudmarketplaceconfig.constraints.gatekeeper.sh/cloudmarketplaceconfig                        0

NAME                                                  ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
datalocation.constraints.gatekeeper.sh/datalocation                        0
```

Policy Controller can also be integrated with Security Command Center for improved reporting of the audit violations. This is detailed in this [guide](https://cloud.google.com/architecture/reporting-policy-controller-audit-violations-security-command-center)

## Clean Up

1. Remove resources from git to delete them from config controller.

```shell
git rm -rf configs/*
mkdir configs/
touch configs/.gitkeep
git add .
git commit -m "deleted guardrails solution"
git push
```

2. Delete the manually created resources. Make sure you are in the same directory as the following file `config-management.yaml  gitops-iam.yaml   repo.yaml  service.yaml`.

```shell
kubectl delete -f config-management.yaml,gitops-iam.yaml,repo.yaml,service.yaml
```

3. Delete Config Controller

Before deleting the resource check to make sure the GCP resources have been removed.

```shell
kubectl get gcp -n config-control
```

If the result is `No resources found in config-control namespace.`, then you are good to proceed. If you skip this step and delete the config controller instance then these resources will persist in your GCP environment.

```shell
gcloud anthos config controller delete --location=us-central1 ${CONFIG_CONTROLLER_NAME}
```
