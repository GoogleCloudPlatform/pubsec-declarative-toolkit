# Remote SSH to Compute Engine

This example creates a firewall rule in the host project to allow SSH access to Google Compute Engine via IAP.

## IAM
The following permissions are required on the project for group(s) of users who need access:

```yaml
# iam-iap.yaml
# Grant GCP role IAP-Secured Tunnel User to instance-admin
# 'instance-admin' can be added to setters.yaml, or replace member values below
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: instance-admin-iaptunnelresourceaccessor-permissions
  annotations:
    cnrm.cloud.google.com/project-id: project-id # kpt-set: ${project-id}
    cnrm.cloud.google.com/ignore-clusterless: "true"
spec:
  resourceRef:
    apiVersion: resourcemanager.cnrm.cloud.google.com/v1beta1
    kind: Project
    external: project-id # kpt-set: ${project-id}
  role: roles/iap.tunnelResourceAccessor
  member: "group:group@domain.com" # kpt-set: ${instance-admin}
---
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: instance-admin-computeinstanceadmin-permissions
  annotations:
    cnrm.cloud.google.com/project-id: project-id # kpt-set: ${project-id}
    cnrm.cloud.google.com/ignore-clusterless: "true"
spec:
  resourceRef:
    apiVersion: resourcemanager.cnrm.cloud.google.com/v1beta1
    kind: Project
    external: project-id # kpt-set: ${project-id}
  role: roles/compute.instanceAdmin.v1
  member: "group:group@domain.com" # kpt-set: ${instance-admin}
```
