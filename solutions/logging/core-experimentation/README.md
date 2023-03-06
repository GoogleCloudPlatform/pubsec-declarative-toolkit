<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# core-experimentation-logging-package


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
**`Note:`** The [core-experimentation](../core-experimentation/) package must be deployed before deploying the `client-experimentation` logging package.

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Package to deploy core-experimentation logging solution

## Setters

|           Name           |          Value           | Type | Count |
|--------------------------|--------------------------|------|-------|
| billing-id               |               0000000000 | str  |     1 |
| logging-prj-id           | logging-prj-id-12345     | str  |    17 |
| management-project-id    | management-project-12345 | str  |     2 |
| org-id                   |               0000000000 | str  |     1 |
| retention-in-days        |                        1 | int  |     2 |
| retention-locking-policy | false                    | bool |     2 |

## Sub-packages

This package has no sub-packages.

## Resources

|            File            |                  APIVersion                   |       Kind       |                                 Name                                 | Namespace |
|----------------------------|-----------------------------------------------|------------------|----------------------------------------------------------------------|-----------|
| cloud-logging-buckets.yaml | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogBucket | security-log-bucket                                                  | logging   |
| cloud-logging-buckets.yaml | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogBucket | platform-and-component-log-bucket                                    | logging   |
| folder-sink.yaml           | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink   | platform-and-component-log-sink                                      | logging   |
| gke-kcc-sink.yaml          | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink   | gke-kcc-cluster-platform-and-component-log-sink                      | logging   |
| gke-kcc-sink.yaml          | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink   | gke-kcc-cluster-disable-default-bucket                               | logging   |
| org-sink.yaml              | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink   | security-log-sink                                                    | logging   |
| project-iam.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy | security-log-bucket-writer-permissions                               | projects  |
| project-iam.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy | platform-and-component-log-bucket-writer-permissions                 | projects  |
| project-iam.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy | gke-kcc-cluster-platform-and-component-log-bucket-writer-permissions | projects  |
| project-iam.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMAuditConfig   | logging-project-data-access-log-config                               | projects  |
| project.yaml               | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project          | logging-prj-id                                                       | projects  |

## Resource References

- [IAMAuditConfig](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamauditconfig)
- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)
- [LoggingLogBucket](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogbucket)
- [LoggingLogSink](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogsink)
- [Project](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/project)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/logging/core-experimentation@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd ".//solutions/logging/core-experimentation/"
    ```

1.  Edit the function config file(s):
    - setters.yaml

1.  Execute the function pipeline
    ```shell
    kpt fn render
    ```

1.  Initialize the resource inventory
    ```shell
    kpt live init --namespace ${NAMESPACE}
    ```
    Replace `${NAMESPACE}` with the namespace in which to manage
    the inventory ResourceGroup (for example, `config-control`).

1.  Apply the package resources to your cluster
    ```shell
    kpt live apply
    ```

1.  Wait for the resources to be ready
    ```shell
    kpt live status --output table --poll-until current
    ```

<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->

# core-experimentation-logging-package - continued
**TODO:** Move documentation to docs repo?

## Core-Experimentation Logging Solution Overview

This package deploys the following resources:

- Log bucket for Security Logs (Cloud Audit, Access Transparency logs, and Data Access Logs)

    - Retention in Days configurable via setters.yaml

        ```yaml
        retention-in-days: 1
        ```
    - Retention locking policy configurable via setters.yaml

        ```yaml
        retention-locking-policy: true
        ```
- Log bucket for platform and component logs for resources under the `tests` folder

    - Retention in Days configurable via setters.yaml

        ```yaml
        retention-in-days: 1
        ```
    - Retention locking policy configurable via setters.yaml
        ```yaml
        retention-locking-policy: true
        ```

- Organizational log sink for Security Logs (Cloud Audit, Access Transparency, and Data Access Logs)

    - Include all child resources is enabled:

        ```yaml
        includeChildren: true
        ```

    - Destination: Log bucket hosted inside the loging project

    - Includes only Security logs: Cloud Audit, Access Transparency, and Data Access Logs

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

    - Destionation: Log bucket hosted inside the loging project

    - No inclusion filter. Includes all Platform and Component logs

    - Excludes all Security logs: Cloud Audit, Access Transparency, and Data Access Logs

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
- Data access log configuration enables data access log collection on the logging project. Logs are routed the the logging project `security-log-bucket` log bucket.

    ```yaml
  # Enable data access log configuration on the logging project
  apiVersion: iam.cnrm.cloud.google.com/v1beta1
  kind: IAMAuditConfig
  metadata:
    name: logging-project-data-access-log-config
    namespace: projects
    annotations:
      config.kubernetes.io/depends-on: resourcemanager.cnrm.cloud.google.com/namespaces/projects/Project/${logging-prj-id} # kpt-set: resourcemanager.cnrm.cloud.google.com/namespaces/projects/Project/${logging-prj-id}
  spec:
    service: allServices
    auditLogConfigs:
      - logType: ADMIN_READ
      - logType: DATA_READ
      - logType: DATA_WRITE
    resourceRef:
      kind: Project
      name: logging-prj-id # kpt-set: ${logging-prj-id}
      namespace: projects
    ```

- IAM permission to allow the service account tied to the organization sink to write logs into the security log bucket
- IAM permission to allow the service account tied to the folder sink to write logs into the platform and component log bucket