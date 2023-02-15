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

## Deployed Resources

Table of deployed resources:

| File                       | Resource Kind    | Namespace/metadata name                                    | Description |
| -------------------------- | ---------------- | ---------------------------------------------------------- | ----------- |
| cloud-logging-buckets.yaml | LoggingLogBucket | logging/audit-log-bucket                                   | Log bucket to store landing zone organization security logs (Audit and Access Transparancy Logs)|
| cloud-logging-buckets.yaml | LoggingLogBucket | logging/platform-component-log-bucket                      |             |
| folder-sinks.yaml          | LoggingLogSink   | logging/platform-component-log-bq-folder-sink              |             |
| folder-sinks.yaml          | LoggingLogSink   | logging/platform-component-log-bucket-folder-sink          |             |
| folder-sinks.yaml          | BigQueryDataset  | logging/platformcomponenttestinglogs                       |             |
| org-sinks.yaml             | LoggingLogSink   | logging/audit-log-bq-sink                                  |             |
| org-sinks.yaml             | LoggingLogSink   | logging/audit-log-bucket-sink                              |             |
| org-sinks.yaml             | BigQueryDataset  | logging/securitylogs                                       |             |
| project-iam.yaml           | IAMPartialPolicy | projects/audit-log-bq-data-owner-permissions               |             |
| project-iam.yaml           | IAMPolicyMember  | projects/audit-log-bq-data-viewer-permissions              |             |
| project-iam.yaml           | IAMPolicyMember  | projects/audit-log-bq-job-user-permissions                 |             |
| project-iam.yaml           | IAMPartialPolicy | projects/audit-log-bucket-writer-permissions               |             |
| project-iam.yaml           | IAMPartialPolicy | projects/platform-component-log-bq-folder-sink-permissions |             |
| project-iam.yaml           | IAMPartialPolicy | projects/platform-component-log-bucket-writer-permissions  |             |
| project.yaml               | Project          | projects/audit-prj-id                                      |             |
| services.yaml              | Service          | projects/audit-prj-id                                      |             |
| setters.yaml               | ConfigMap        | setters                                                    |             |