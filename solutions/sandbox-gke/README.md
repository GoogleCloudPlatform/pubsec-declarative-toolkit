# GCP PBMM Sandbox Environment

## What is Deployed in this package
- 30 Day Guardrails Enforcement
- Private GKE Cluster
- Logging/Monitoring for GKE Cluster
    - Big Query Log Sink
    - GKE Metering



### Apply the Configs

#### Manually

First make sure we have access to the target cluster and are pointing to the correct namespace
```
gcloud container clusters get-credentials $CLUSTER --region $REGION
kubens config-control
```

First we will want to initilize the directory with Git so we can keep track of local changes vs upstream changes. This will be needed to pull new updates from the `upstream` repository using `kpt pkg update`.

```
git init
```

Once we have done that we can start editing the `setters.yaml` file and populate the correct information. The values in the `setters` file will be used to populate the infrastructure YAML.

To populate the template with the `setters` inputs run `kpt fn render`.
```

With the changes populated let's save the changes in `git`.
```
git add .
git commit -m "description of the changes made"
```

Before we deploy the changes let's make sure we're in the correct `namespace` by running `kubens config-control`. Now we can run the `kpt` commands to deploy the configs to the Cluster.

```
kpt live init
kpt live apply
```

#### GitOps via Config Sync

