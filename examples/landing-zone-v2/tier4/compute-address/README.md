# Compute Address

This example creates an external compute address reserved for a tier 3 DNS A Record.

## IAM
This permission is required for the tier4-sa. It can be granted from tier3.

```yaml
# Grant GCP role Compute Public IP Admin to tier4-sa GCP SA
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: project-id-tier4-sa-compute-public-ip-admin-host-project-id-permissions # kpt-set: ${project-id}-tier4-sa-compute-public-ip-admin-${project-id}-permissions
  namespace: client-name-projects # kpt-set: ${client-name}-projects
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
    config.kubernetes.io/depends-on: resourcemanager.cnrm.cloud.google.com/namespaces/client-name-projects/Project/project-id # kpt-set: resourcemanager.cnrm.cloud.google.com/namespaces/${client-name}-projects/Project/${project-id}
spec:
  resourceRef:
    apiVersion: resourcemanager.cnrm.cloud.google.com/v1beta1
    kind: Project
    name: project-id # kpt-set: ${project-id}
  role: roles/compute.publicIpAdmin
  member: "serviceAccount:tier4-sa@project-id.iam.gserviceaccount.com" # kpt-set: serviceAccount:tier4-sa@${project-id}.iam.gserviceaccount.com
```
