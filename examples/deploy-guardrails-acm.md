# Deploy a Guardrails Environment using the Anthos Config Management

## Getting Started

Our first step will be to provision a Config Controller Instance to deploy our infrastructure with.

To do that follow the steps outlined in the advanced [install guide](../docs/advanced-install.md). This process should take about 20mins.

## Setting Up ACM

Now that we have a Config Controller Instance up we'll want to create a Source Repository for us to store our infrastructure code in. For this example we will be using Cloud Source Repositories because we can quickly create it and access it using Workload Identity, so no keys to manage! If you already have a favorite source repository you should be able to use that following these [instructions](https://cloud.google.com/anthos-config-management/docs/how-to/installing-config-sync#git-creds-secret).

The following steps are modified from this [guide](https://cloud.google.com/anthos-config-management/docs/how-to/config-controller-setup#manage-resources)

0. Set Environment Variables
```
export PROJECT_ID=<config-controller-project-id>
export CONFIG_CONTROLLER_NAME=<name-of-config-controller-instance>
```

1. Enable source repository service.

```
cat > service << EOF
apiVersion: serviceusage.cnrm.cloud.google.com/v1beta1
kind: Service
metadata:
  name: sourcerepo.googleapis.com
  namespace: config-control
EOF
```

2. Apply the manifest

```
kubectl apply -f service.yaml
```

This should take a few minutes for the service to enable. You can check on it's status or watch it deploy by running `kubectl wait -f service.yaml --for=condition=Ready`

3. Create the Repository Configs
```
cat > repo.yaml << EOF

apiVersion: sourcerepo.cnrm.cloud.google.com/v1beta1
kind: SourceRepoRepository
metadata:
  name: guardrails-configs
  namespace: config-control
EOF
```

4. Create the reposiory
```
kubectl apply -f repo.yaml
```

Now we have our base infrastructure in place and we can now set up some IAM so the ACM instance we will create can access the Source Repo.

1. Create the IAM permissions. This is grant source repository reader access to the ACM service account.
```
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

2. Apply the configs

```
kubectl apply -f gitops-iam.yaml
```

3. Configure the ACM instance.

```
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
    syncRepo: https://source.developers.google.com/p/${PROJECT_ID}/r/guardrails-infra
  sourceFormat: unstructured
EOF
```

4. Deploy ACM

```
kubectl apply -f config-management.yaml
```

This will take a few minutes to deploy and while we wait for that we'll get the guardrails configuration up and running.

## Guardrails installation.

1. Get Guardrails Package.

```
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails guardrails
```

This will pull down the configurations required to deploy the guardrails infrastructure.

2. Our next step will be to populate the setters file with any relevant information.

```
cd guardrails
```

Open the `setters.yaml` file in your favorite text editor. The most important fields here are at the top of the file.

3. Populate the config files with the setters information.
```
kpt fn render

# Succesfull Output
Package "guardrails-infra/configs/hierarchy": 
[RUNNING] "gcr.io/kpt-fn/generate-folders:v0.1"
[PASS] "gcr.io/kpt-fn/generate-folders:v0.1" in 1.2s

Package "guardrails-infra": 
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

This will populate the required fields with the informatin you set in `setters.yaml`

4. Clone the repo that you created in the previous steps.
```
gcloud source repos clone guardrails-infra
```

```
mv guardrails/* guardrails-infra
rm -rf guardrails
```

```
cd guardrails-infra
```

Create and switch to `main` branch.
```
git checkout -b main
```

5. Commit your changes to git and push the configs to the repository.

```
git add .
git commit -m "Add Guardrails solution"
git push
```

After a few minutes you should start to see the resources deploying into the Config Controller instance

```
kubectl get gcp -n config-control

#output should resemble this
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

## Policy Enforcement

Now that we are able to deploy our infrastructure the next thing we might want to do is enforce policy to ensure we're doing things in a compliant manner. Luckily we can do this with [Policy Controller](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller) which is included in Anthos Config Management and preinstalled in our Config Controller instance. Policy Controller allows us to write custom policy as code and have it enforced within our Config Controller instance.

To get you started you can use the policies from our [guardrails-policies](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/guardrails-policies) package. At the time of this writing includes 3 policies (data-location, network-security-services, cloud-marketplace) to help enforce 30 Guardrails policies. 

Using the infrastructure we've already deployed we'll download the `guardrails-policy` package and do some local testing.

```
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails-policies guardrails-policies
```

Now we'll need to add the [gatekeeper](https://catalog.kpt.dev/gatekeeper/v0.2/) function to our `Kptfile` so that it will execute on a `kpt fn render`. To do that add the following to the `validators` section.

```
  validators:
    - image: gcr.io/kpt-fn/kubeval:v0.2
      configMap:
        ignore_missing_schemas: "true"
        strict: "true"
    - image: gcr.io/kpt-fn/gatekeeper:v0.2.1
```

With that added and the file saved running `kpt fn render` should pass. Here's the abbreviated output.

```
...
[RUNNING] "gcr.io/kpt-fn/kubeval:v0.2"
[PASS] "gcr.io/kpt-fn/kubeval:v0.2" in 5.4s
[RUNNING] "gcr.io/kpt-fn/gatekeeper:v0.2.1"
[PASS] "gcr.io/kpt-fn/gatekeeper:v0.2.1" in 1.8s
```

Now let's modify some files so that we get a failure to show how this works. Open the following file in your favorite code editor `guardrails-policies/05-data-location/constraint.yaml`

This is the file that you will pass in parameters to decide what regions are allowed or not allowed in your environment and should look like the following.

```
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

```
- "northamerica-northeast1"
- "northamerica-northeast2"
```

Now this policy will only allow global resources to be deployed. Run `kpt fn render` again and things should now fail and you should get output similar to this.

```
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

## Clean Up

1. Remove resources from git to delete them from config controller.
```
git rm -rf configs/*
git commit -m "deleted guardrails solution"
```

2. Delete Config Controller
```
gcloud anthos config controller delete --location=us-central1 ${CONFIG_CONTROLLER_NAME}
```