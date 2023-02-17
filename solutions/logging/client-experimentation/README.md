# Client-Experimentation Logging Solution Package

A package to deploy the client-experimentation logging solution inside the experimentation landing-zone.

## Package Contents

`kpt pkg tree`

```
Package "client-experimentation"
├── [Kptfile]  Kptfile client-experimentation-logging-package
├── [cloud-logging-bucket.yaml]  LoggingLogBucket logging/platform-component-client1-log-bucket
├── [folder-sinks.yaml]  LoggingLogSink logging/platform-component-log-client1-bucket-folder-sink
├── [project-iam.yaml]  IAMPartialPolicy projects/platform-component-log-client1-bucket-writer-permissions
└── [setters.yaml]  ConfigMap setters
```

## Deployed Google Cloud Platform Resources

A table listing the GCP resources deployed by this logging solution package:

| File                      | Resource         | Kind Namespace/Metadata Name                                      | Description                                                                                                 |
| ------------------------- | ---------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| cloud-logging-bucket.yaml | LoggingLogBucket | logging/platform-component-client1-log-bucket                     | Log Bucket for platform and component logs                                                                  |
| folder-sinks.yaml         | LoggingLogSink   | logging/platform-component-log-client1-bucket-folder-sink         | Folder sink for platform and component logs to Log Bucket                                                   |
| project-iam.yaml          | IAMPartialPolicy | projects/platform-component-log-client1-bucket-writer-permissions | IAM permission to allow log sink service account to write logs to the Log Bucket in the audit project       |
