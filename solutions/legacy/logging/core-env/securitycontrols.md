# Security Controls

## AC-3(7) ACCESS ENFORCEMENT | ROLE-BASED ACCESS CONTROL

AC-3(7) – Write access to the logs is constrained by IAM permissions to just the log sinks.
Added this control to project-iam.yaml in bindings where bucketWriter role is assigned.

## AU-2 AUDITABLE EVENTS

AU-2 – Event families being audited are set here. Added this control to folder-sink.yaml,
gke-kcc-sink.yaml, org-sink.yaml immediately preceding the filter including/excluding
various log types

Ops Note: This is an org control so the AU-2 tagging in the code is there to support the
narrative Ops will write to demonstrate the org requirements

### AU-4(1) AUDIT STORAGE CAPACITY | TRANSFER TO ALTERNATE STORAGE

AU-4(1) – Logs are being sent to a logging project which is separate from the projects
performing actions which generate log entries. Added to the cloud-logging-buckets.yaml
where separate logging project is selected as target.

## AU-8 TIME STAMPS

AU-8 – Time stamps for audit records use internal Google time which is recorded in
RFC3339 UTC format in log entries (see GCP documentation for LogEntry object, timestamp field)

## AU-9 PROTECTION OF AUDIT INFORMATION

AU-9 – Retention policies and policy locks are implemented so log contents is immutable. Added to
cloud-logging-buckets.yaml prior to locked and retentionDays entries. Also added to setters.yaml
as previous entries are set from here.

### AU-9(2) PROTECTION OF AUDIT INFORMATION | AUDIT BACKUP ON SEPARATE PHYSICAL SYSTEMS / COMPONENTS

AU-9(2) – Logs sent to separate project, same response as AU-4(1)

## AU-11 AUDIT RECORD RETENTION

AU-11 – Audit log retention, same response as AU-9

## AU-12(A)

Same as AU-2 (this control is the implementation of AU-2)

## AU-12(C)

Same as AU-2 (this control is the implementation of AU-2)
