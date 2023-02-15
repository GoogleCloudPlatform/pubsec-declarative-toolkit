# Tenant-Experimentation Logging Solution Package

A package to deploy the tenant-experimentation logging solution inside the experimentation landing-zone.

## Package Contents

`kpt pkg tree`

```
Package "tenant-experimentation"
├── [Kptfile]  Kptfile tenant-experimentation-logging-package
├── [cloud-logging-bucket.yaml]  LoggingLogBucket logging/platform-component-tenant1-log-bucket
├── [folder-sinks.yaml]  LoggingLogSink logging/platform-component-log-tenant1-bq-folder-sink
├── [folder-sinks.yaml]  LoggingLogSink logging/platform-component-log-tenant1-bucket-folder-sink
├── [folder-sinks.yaml]  BigQueryDataset logging/platformcomponenttenant1logs
├── [project-iam.yaml]  IAMPartialPolicy projects/platform-component-log-tenant1-bucket-writer-permissions
├── [project-iam.yaml]  IAMPartialPolicy projects/platform-component-log-tenant1-bq-writer-permissions
└── [setters.yaml]  ConfigMap setters
```

## Deployed Google Cloud Platform Resources

A table listing the GCP resources deployed by this logging solution package:

| File                      | Resource         | Kind Namespace/Metadata Name                                      | Description                                                                                                 |
| ------------------------- | ---------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| cloud-logging-bucket.yaml | LoggingLogBucket | logging/platform-component-tenant1-log-bucket                     | Log Bucket for platform and component logs                                                                  |
| folder-sinks.yaml         | LoggingLogSink   | logging/platform-component-log-tenant1-bq-folder-sink             | Folder sink for platform and component logs to BigQuery Dataset                                             |
| folder-sinks.yaml         | LoggingLogSink   | logging/platform-component-log-tenant1-bucket-folder-sink         | Folder sink for platform and component logs to Log Bucket                                                   |
| folder-sinks.yaml         | BigQueryDataset  | logging/platformcomponenttenant1logs                              | BigQuery Dataset for Tenant Resources                                                                       |
| project-iam.yaml          | IAMPartialPolicy | projects/platform-component-log-tenant1-bucket-writer-permissions | IAM permission to allow log sink service account to write logs to the Log Bucket in the audit project       |
| project-iam.yaml          | IAMPartialPolicy | projects/platform-component-log-tenant1-bq-writer-permissions     | IAM permission to allow log sink service account to write logs to the BigQuery Dataset in the audit project |
