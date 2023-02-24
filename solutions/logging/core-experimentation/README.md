# Core-Experimentation Logging Solution Package

A package to deploy the core-experimentation logging solution inside the experimentation landing-zone.

**`Note:`** This package must be deployed before the `client-experimentation` logging package.

# Core-Experimentation Logging Solution Overview

This package deploys the following resources:

- Log bucket for Security Logs (Cloud Audit and Access Transparency logs)

    - Retention in Days configurable via setters.yaml

        ```yaml
        retention-in-days: 365
        ```
    - Retention locking policy configurable via setters.yaml

        ```yaml
        retention-locking-policy: true
        ```
- Log bucket for platform and component logs for resources under the `tests` folder

    - Retention in Days configurable via setters.yaml

        ```yaml
        retention-in-days: 365
        ```
    - Retention locking policy configurable via setters.yaml
        ```yaml
        retention-locking-policy: true
        ```

- Organizational log sink for Security Logs (Cloud Audit and Access Transparency logs)

    - Include all child resources is enabled:

        ```yaml
        includeChildren: true
        ```

    - Destionation: Log bucket hosted inside the audit project

    - Includes only Security logs: Cloud Audit and Access Transparency Logs

        ```yaml
          filter: |-
            LOG_ID("cloudaudit.googleapis.com/activity") OR LOG_ID("externalaudit.googleapis.com/activity")
            OR LOG_ID("cloudaudit.googleapis.com/data_access") OR LOG_ID("externalaudit.googleapis.com/data_access")
            OR LOG_ID("cloudaudit.googleapis.com/system_event") OR LOG_ID("externalaudit.googleapis.com/system_event")
            OR LOG_ID("cloudaudit.googleapis.com/policy") OR LOG_ID("externalaudit.googleapis.com/policy")
            OR LOG_ID("cloudaudit.googleapis.com/access_transparency") OR LOG_ID("externalaudit.googleapis.com/access_transparency")
        ```

    - **`Note:`** The permission required to create the organizational sink is set under the [logging namespace](../../landing-zone-v2/namespaces/logging.yaml#L28)

- Folder log sink for platform and component logs for resources under the `tests` folder

    - Destionation: Log bucket hosted inside the audit project

    - No inclusion filter. Includes all Platform and Component logs

    - Excludes all Security logs: Cloud Audit and Access Transparency Logs

        ```yaml
          exclusions:
            - description: Exclude Security logs
              disabled: false
              filter: |-
                LOG_ID("cloudaudit.googleapis.com/activity") OR LOG_ID("externalaudit.googleapis.com/activity")
                OR LOG_ID("cloudaudit.googleapis.com/data_access") OR LOG_ID("externalaudit.googleapis.com/data_access")
                OR LOG_ID("cloudaudit.googleapis.com/system_event") OR LOG_ID("externalaudit.googleapis.com/system_event")
                OR LOG_ID("cloudaudit.googleapis.com/policy") OR LOG_ID("externalaudit.googleapis.com/policy")
                OR LOG_ID("cloudaudit.googleapis.com/access_transparency") OR LOG_ID("externalaudit.googleapis.com/access_transparency")
              name: exclude-security-logs
        ```

```
# TODO: Revise how data access logs should be enabled. Per Folder or Project?
        Perhaps it should be configured at the folder level since the data access log config should reside inside
        the logging package. The only requirement to use folder ref is that any projects under the folder requires
        a depends-on annotation.
```

- Data access log configuration enables data access log collection on the audit project. Logs are routed the the
audit project log bucket.

    ```yaml
    # Enable data access log configuration on the audit project
    apiVersion: iam.cnrm.cloud.google.com/v1beta1
    kind: IAMAuditConfig
    metadata:
      name: audit-project-data-access-log-config
      namespace: hierarchy
      annotations:
        cnrm.cloud.google.com/blueprint: 'kpt-fn'
        config.kubernetes.io/depends-on: resourcemanager.cnrm.cloud.google.com/namespaces/hierarchy/Folder/testing
    spec:
      service: allServices
      auditLogConfigs:
        - logType: ADMIN_READ
        - logType: DATA_READ
        - logType: DATA_WRITE
      resourceRef:
        kind: Project
        external: audit-prj-id # kpt-set: ${audit-prj-id}
        namespace: projects
    ```
- IAM permission to allow the service account tied to the organization sink to write logs into the security log bucket
- IAM permission to allow the service account tied to the folder sink to write logs into the platform and component log bucket

## Usage
### Fetch the package

```
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/logging/core-experimentation
```

Details: https://kpt.dev/reference/cli/pkg/get/

### View package content

`kpt pkg tree core-experimentation`

Details: https://kpt.dev/reference/cli/pkg/tree/

```
Package "core-experimentation"
├── [Kptfile]  Kptfile core-experimentation-logging-package
├── [cloud-logging-buckets.yaml]  LoggingLogBucket logging/audit-log-bucket
├── [cloud-logging-buckets.yaml]  LoggingLogBucket logging/platform-component-log-bucket
├── [folder-sink.yaml]  LoggingLogSink logging/platform-component-log-bucket-folder-sink
├── [org-sink.yaml]  LoggingLogSink logging/audit-log-bucket-sink
├── [project-iam.yaml]  IAMAuditConfig hierarchy/audit-project-data-access-log-config
├── [project-iam.yaml]  IAMPartialPolicy projects/audit-log-bucket-writer-permissions
├── [project-iam.yaml]  IAMPartialPolicy projects/platform-component-log-bucket-writer-permissions
├── [project.yaml]  Project projects/audit-prj-id
└── [setters.yaml]  ConfigMap setters
```

## Deployed Google Cloud Platform Resources

A table listing the GCP resources deployed by this logging solution package:

| File                       | Resource Kind    | Namespace/metadata Name                                   | Description                                                                                                 |
| -------------------------- | ---------------- | --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| cloud-logging-buckets.yaml | LoggingLogBucket | logging/audit-log-bucket                                  | Log bucket for organization security logs (Audit and Access Transparency Logs)                              |
| cloud-logging-buckets.yaml | LoggingLogBucket | logging/platform-component-log-bucket                     | Log Bucket for platform and component logs                                                                  |
| folder-sink.yaml          | LoggingLogSink   | logging/platform-component-log-bucket-folder-sink         | Folder sink for platform and component logs to Log Bucket                                                   |
| org-sink.yaml             | LoggingLogSink   | logging/audit-log-bucket-sink                             | Organization sink for security logs to Log Bucket                                                           |
| project-iam.yaml           | IAMPartialPolicy | projects/audit-project-data-access-log-config              | Enables data access logging       |
| project-iam.yaml           | IAMPartialPolicy | projects/audit-log-bucket-writer-permissions              | IAM permission to allow log sink service account to write logs to the Log Bucket in the audit project       |
| project-iam.yaml           | IAMPartialPolicy | projects/platform-component-log-bucket-writer-permissions | IAM permission to allow log sink service account to write logs to the Log Bucket in the audit project       |
| project.yaml               | Project          | projects/audit-prj-id                                     | Creates the audit project                                                                                   |