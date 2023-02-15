# Core-Experimentation Logging Solution Package

A package to deploy the core-experimentation logging solution inside the experimentation landing-zone.

## Package Contents

`kpt pkg tree`

```
Package "core-experimentation"
├── [Kptfile]  Kptfile core-experimentation-logging-package
├── [cloud-logging-buckets.yaml]  LoggingLogBucket logging/audit-log-bucket
├── [cloud-logging-buckets.yaml]  LoggingLogBucket logging/platform-component-log-bucket
├── [folder-sinks.yaml]  LoggingLogSink logging/platform-component-log-bq-folder-sink
├── [folder-sinks.yaml]  LoggingLogSink logging/platform-component-log-bucket-folder-sink
├── [folder-sinks.yaml]  BigQueryDataset logging/platformcomponenttestinglogs
├── [org-sinks.yaml]  LoggingLogSink logging/audit-log-bq-sink
├── [org-sinks.yaml]  LoggingLogSink logging/audit-log-bucket-sink
├── [org-sinks.yaml]  BigQueryDataset logging/securitylogs
├── [project-iam.yaml]  IAMPartialPolicy projects/audit-log-bq-data-owner-permissions
├── [project-iam.yaml]  IAMPolicyMember projects/audit-log-bq-data-viewer-permissions
├── [project-iam.yaml]  IAMPolicyMember projects/audit-log-bq-job-user-permissions
├── [project-iam.yaml]  IAMPartialPolicy projects/audit-log-bucket-writer-permissions
├── [project-iam.yaml]  IAMPartialPolicy projects/platform-component-log-bq-folder-sink-permissions
├── [project-iam.yaml]  IAMPartialPolicy projects/platform-component-log-bucket-writer-permissions
├── [project.yaml]  Project projects/audit-prj-id
├── [services.yaml]  Service projects/audit-prj-id
└── [setters.yaml]  ConfigMap setters
```

## Deployed Google Cloud Platform Resources

A table listing the GCP resources deployed by this logging solution package:

| File                       | Resource Kind    | Namespace/metadata name                                    | Description                                                                                                 |
| -------------------------- | ---------------- | ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| cloud-logging-buckets.yaml | LoggingLogBucket | logging/audit-log-bucket                                   | Log bucket for organization security logs (Audit and Access Transparancy Logs)                              |
| cloud-logging-buckets.yaml | LoggingLogBucket | logging/platform-component-log-bucket                      | Log Bucket for platform and component logs                                                                  |
| folder-sinks.yaml          | LoggingLogSink   | logging/platform-component-log-bq-folder-sink              | Folder sink for platform and component logs to BigQuery Dataset                                             |
| folder-sinks.yaml          | LoggingLogSink   | logging/platform-component-log-bucket-folder-sink          | Folder sink for platform and component logs to Log Bucket                                                   |
| folder-sinks.yaml          | BigQueryDataset  | logging/platformcomponenttestinglogs                       | BigQuery Dataset for Testing Resources                                                                      |
| org-sinks.yaml             | LoggingLogSink   | logging/audit-log-bq-sink                                  | Organization sink for security logs to BigQuery Dataset                                                     |
| org-sinks.yaml             | LoggingLogSink   | logging/audit-log-bucket-sink                              | Organization sink for security logs to Log Bucket                                                           |
| org-sinks.yaml             | BigQueryDataset  | logging/securitylogs                                       | BigQuery Dataset for security logs                                                                          |
| project-iam.yaml           | IAMPartialPolicy | projects/audit-log-bq-data-owner-permissions               | IAM permission to allow log sink service account to write logs to the BigQuery Dataset in the audit project |
| project-iam.yaml           | IAMPolicyMember  | projects/audit-log-bq-data-viewer-permissions              | IAM permission to restrict access to BigQuery in the audit project                                          |
| project-iam.yaml           | IAMPolicyMember  | projects/audit-log-bq-job-user-permissions                 | IAM permission to allow running BigQuery Jobs (Queries) in the audit project                                |
| project-iam.yaml           | IAMPartialPolicy | projects/audit-log-bucket-writer-permissions               | IAM permission to allow log sink service account to write logs to the Log Bucket in the audit project       |
| project-iam.yaml           | IAMPartialPolicy | projects/platform-component-log-bq-folder-sink-permissions | IAM permission to allow log sink service account to write logs to the BigQuery Dataset in the audit project |
| project-iam.yaml           | IAMPartialPolicy | projects/platform-component-log-bucket-writer-permissions  | IAM permission to allow log sink service account to write logs to the Log Bucket in the audit project       |
| project.yaml               | Project          | projects/audit-prj-id                                      | Creates the audit project                                                                                   |
| services.yaml              | Service          | projects/audit-prj-id                                      | Enables the BigQuery API                                                                                    |