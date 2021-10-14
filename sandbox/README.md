# GCP PBMM Sandbox Environment

## What is Deployed in this package
- 30 Day Guardrails Enforcement
- Private GKE Cluster
- Logging/Monitoring for GKE Cluster
    - Big Query Log Sink
    - GKE Metering



### Apply the Configs

First make sure we have access to the target cluster and are pointing to the correct namespace
```
gcloud container clusters get-credentials $CLUSTER --region $REGION
kubens config-control
```

```
kpt live init
kpt live apply
```