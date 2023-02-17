# Client-Experimentation Logging Solution Package

A package to deploy the client-experimentation logging solution inside the experimentation landing-zone.

**`Note:`** The [core-experimentation](../core-experimentation/) package must be deployed before deploying the `client-experimentation` logging package.

# Client-Experimentation Logging Solution Overview

This package deploys the following resources:

- Log bucket for client platform and component logs located under the `clients` folder

    - Retention in Days configurable via setters.yaml

        ```yaml
        retention-in-days: 1
        ```
    - Retention locking policy configurable via setters.yaml
        ```yaml
        retention-locking-policy: false
        ```

- Folder log sink for platform and component logs for resources under the `clients` folder

    - Destionation: Log bucket hosted inside the audit project

    - Includes the following types of logs:
        - Cloud DNS, Cloud NAT, Firewall Rules, VPC Flow, and HTTP(S)

        ```yaml
        filter: |-
            LOG_ID("dns.googleapis.com/dns_queries")
            OR (LOG_ID("compute.googleapis.com/nat_flows") AND resource.type="nat_gateway")
            OR (LOG_ID("compute.googleapis.com/firewall") AND resource.type="gce_subnetwork")
            OR (LOG_ID("compute.googleapis.com/vpc_flows") AND resource.type="gce_subnetwork")
            OR (LOG_ID("requests") AND resource.type="http_load_balancer")
        ```

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

    - IAM permission to allow the service account tied to the folder log sink to write logs into the platform and component log bucket

## Usage
### Fetch the package

```
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/logging/client-experimentation
```

Details: https://kpt.dev/reference/cli/pkg/get/

### View the package content

Details: https://kpt.dev/reference/cli/pkg/tree/

`kpt pkg tree client-experimentation`

```
Package "client-experimentation"
├── [Kptfile]  Kptfile client-experimentation-logging-package
├── [cloud-logging-bucket.yaml]  LoggingLogBucket logging/platform-component-client1-log-bucket
├── [folder-sink.yaml]  LoggingLogSink logging/platform-component-log-client1-bucket-folder-sink
├── [project-iam.yaml]  IAMPartialPolicy projects/platform-component-log-client1-bucket-writer-permissions
└── [setters.yaml]  ConfigMap setters
```

## Deployed Google Cloud Platform Resources

A table listing the GCP resources deployed by this logging solution package:

| File                      | Resource         | Kind Namespace/Metadata Name                                      | Description                                                                                                 |
| ------------------------- | ---------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| cloud-logging-bucket.yaml | LoggingLogBucket | logging/platform-component-client1-log-bucket                     | Log Bucket for platform and component logs                                                                  |
| folder-sink.yaml         | LoggingLogSink   | logging/platform-component-log-client1-bucket-folder-sink         | Folder sink for platform and component logs to Log Bucket                                                   |
| project-iam.yaml          | IAMPartialPolicy | projects/platform-component-log-client1-bucket-writer-permissions | IAM permission to allow log sink service account to write logs to the Log Bucket in the audit project       |
