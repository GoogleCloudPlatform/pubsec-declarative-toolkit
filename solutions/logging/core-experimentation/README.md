# Core-Experimentation Logging Solution Package

A package to deploy the core-experimentation logging solution inside the experimentation landing-zone.

# Core-Experimentation Logging Solution Overview

This package deploys the following resources:

- Log bucket for Security Logs (Cloud Audit and Access Transparency logs)

    - Retention in Days configurable via setters.yaml

        ```yaml
        retention-in-days: 1
        ```
    - Retention locking policy configurable via setters.yaml

        ```yaml
        retention-locking-policy: false
        ```
- Log bucket for platform and component logs for resources under the `Testing` folder

    - Retention in Days configurable via setters.yaml

        ```yaml
        retention-in-days: 1
        ```
    - Retention locking policy configurable via setters.yaml
        ```yaml
        retention-locking-policy: false
        ```
- BigQuery Dataset for Security Logs (Cloud Audit and Access Transparency logs)

    - Table expiration (in milliseconds) configurable via setters.yaml

        ```yaml
        defaultTableExpirationMs: 31536000000
        ```

- BigQuery Dataset for platform and component logs for resources under the `Testing` folder

    - Table expiration (in milliseconds) configurable via setters.yaml

        ```yaml
        defaultTableExpirationMs: 31536000000
        ```

- Organizational log sinks for Security Logs (Cloud Audit and Access Transparency logs)

    - Include all child resources is enabled:

        ```yaml
        includeChildren: true
        ```

    - Destionations: Log bucket and BigQuery Dataset

    - Includes only Security logs: Cloud Audit and Access Transparency Logs

        ```yaml
          filter: |-
            LOG_ID("cloudaudit.googleapis.com/activity") OR LOG_ID("externalaudit.googleapis.com/activity")
            OR LOG_ID("cloudaudit.googleapis.com/system_event") OR LOG_ID("externalaudit.googleapis.com/system_event")
            OR LOG_ID("cloudaudit.googleapis.com/policy") OR LOG_ID("externalaudit.googleapis.com/policy")
            OR LOG_ID("cloudaudit.googleapis.com/access_transparency") OR LOG_ID("externalaudit.googleapis.com/access_transparency")    
        ```

- Folder log sinks for platform and component logs for resources under the `Testing` folder

    - Destionations: Log bucket and BigQuery Dataset

    - No inclusion filter. Includes all Platform and Component logs

    - Excludes all Security logs: Cloud Audit and Access Transparency Logs

        ```yaml
          exclusions:
            - description: Exclude Security logs
              disabled: false
              filter: |-
                LOG_ID("cloudaudit.googleapis.com/activity") OR LOG_ID("externalaudit.googleapis.com/activity")
                OR LOG_ID("cloudaudit.googleapis.com/system_event") OR LOG_ID("externalaudit.googleapis.com/system_event")
                OR LOG_ID("cloudaudit.googleapis.com/policy") OR LOG_ID("externalaudit.googleapis.com/policy")
                OR LOG_ID("cloudaudit.googleapis.com/access_transparency") OR LOG_ID("externalaudit.googleapis.com/access_transparency")
              name: exclude-security-logs
        ```

# Usage
## Fetch the package

```
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/logging/core-experimentation
```

Details: https://kpt.dev/reference/cli/pkg/get/

View package content
kpt pkg tree guardrails-policies Details: https://kpt.dev/reference/cli/pkg/tree/

# Package Contents

`kpt pkg tree core-experimentation`

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
├── [project-iam.yaml]  IAMPartialPolicy projects/platform-component-log-bq-writer-permissions
├── [project-iam.yaml]  IAMPartialPolicy projects/platform-component-log-bucket-writer-permissions
├── [project.yaml]  Project projects/audit-prj-id
├── [services.yaml]  Service projects/audit-prj-id
└── [setters.yaml]  ConfigMap setters
```

## Deployed Google Cloud Platform Resources

A table listing the GCP resources deployed by this logging solution package:

| File                       | Resource Kind    | Namespace/metadata Name                                   | Description                                                                                                 |
| -------------------------- | ---------------- | --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| cloud-logging-buckets.yaml | LoggingLogBucket | logging/audit-log-bucket                                  | Log bucket for organization security logs (Audit and Access Transparency Logs)                              |
| cloud-logging-buckets.yaml | LoggingLogBucket | logging/platform-component-log-bucket                     | Log Bucket for platform and component logs                                                                  |
| folder-sinks.yaml          | LoggingLogSink   | logging/platform-component-log-bq-folder-sink             | Folder sink for platform and component logs to BigQuery Dataset                                             |
| folder-sinks.yaml          | LoggingLogSink   | logging/platform-component-log-bucket-folder-sink         | Folder sink for platform and component logs to Log Bucket                                                   |
| folder-sinks.yaml          | BigQueryDataset  | logging/platformcomponenttestinglogs                      | BigQuery Dataset for Testing Resources                                                                      |
| org-sinks.yaml             | LoggingLogSink   | logging/audit-log-bq-sink                                 | Organization sink for security logs to BigQuery Dataset                                                     |
| org-sinks.yaml             | LoggingLogSink   | logging/audit-log-bucket-sink                             | Organization sink for security logs to Log Bucket                                                           |
| org-sinks.yaml             | BigQueryDataset  | logging/securitylogs                                      | BigQuery Dataset for security logs                                                                          |
| project-iam.yaml           | IAMPartialPolicy | projects/audit-log-bq-data-owner-permissions              | IAM permission to allow log sink service account to write logs to the BigQuery Dataset in the audit project |
| project-iam.yaml           | IAMPolicyMember  | projects/audit-log-bq-data-viewer-permissions             | IAM permission to restrict access to BigQuery in the audit project                                          |
| project-iam.yaml           | IAMPolicyMember  | projects/audit-log-bq-job-user-permissions                | IAM permission to allow running BigQuery Jobs (Queries) in the audit project                                |
| project-iam.yaml           | IAMPartialPolicy | projects/audit-log-bucket-writer-permissions              | IAM permission to allow log sink service account to write logs to the Log Bucket in the audit project       |
| project-iam.yaml           | IAMPartialPolicy | projects/platform-component-log-bq-writer-permissions     | IAM permission to allow log sink service account to write logs to the BigQuery Dataset in the audit project |
| project-iam.yaml           | IAMPartialPolicy | projects/platform-component-log-bucket-writer-permissions | IAM permission to allow log sink service account to write logs to the Log Bucket in the audit project       |
| project.yaml               | Project          | projects/audit-prj-id                                     | Creates the audit project                                                                                   |
| services.yaml              | Service          | projects/audit-prj-id                                     | Enables the BigQuery API                                                                                    |