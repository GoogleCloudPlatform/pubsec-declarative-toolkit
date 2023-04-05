# Security Controls
>
> TODO: This document requires refinement

## AC-3 ACCESS ENFORCEMENT

## AC-3(7) ACCESS ENFORCEMENT | ROLE-BASED ACCESS CONTROL

- Write access to the logs is constrained by IAM permissions to just the log sinks.

This control should be added to project-iam.yaml. Lines 15/16 already have a good explanation of
what’s happening so just add the AC-3(7) tag around there)

## AU-2 AUDITABLE EVENTS

AU-2 – Event families being audited are set here. This control should be added to the folder-sink.yaml,
gke-kcc-sink.yaml and org-sink.yaml with a brief explanation of what’s being audited.
Suggest putting the tag and explanation down around line 35 where the inclusions/exclusions are
This is an org control so the AU-2 tagging in the code is there to support the narrative Ops will write to demonstrate the org requirements

## AU-4 AUDIT STORAGE CAPACITY

## AU-4(1) AUDIT STORAGE CAPACITY | TRANSFER TO ALTERNATE STORAGE

AU-4(1) – Logs are being sent to a logging project which is separate from the projects
performing actions which generate log entries. This control should be added to the
cloud-logging-buckets.yaml with a brief explanation that the logs are in a separate project.
Suggest putting around line 15 which describes buckets

## AU-8 TIME STAMPS

AU-8 – Time stamps for audit records use internal Google time. Statement to that effect should go into securitycontrols.md, will need a reference to some Google documentation (can be found later)

## AU-9 PROTECTION OF AUDIT INFORMATION

AU-9 – Retention policies and policy locks are implemented so log contents is immutable. Include in cloud-logging-buckets.yaml after lines 28 and 46 (i.e. just before the “locked” and “retentionDays” settings. Also add to setters.yaml. Also add notation to project-iam.yaml where roles are being assigned to the sinks (same as AC-3(7))

### AU-9(2) PROTECTION OF AUDIT INFORMATION | AUDIT BACKUP ON SEPARATE PHYSICAL SYSTEMS / COMPONENTS

AU-9(2) – Logs sent to separate project, same response as AU-4(1)

## AU-11 AUDIT RECORD RETENTION

AU-11 – Audit log retention, same response as AU-9 however no reference added to project-iam.yaml as AU-11 doesn’t deal with access

## AU-12 AUDIT GENERATION

## AU-12(A)

## AU-12(C)

AU-12(A), AU-12(C) – This is the implementation of AU-2, so same comments and code locations apply
