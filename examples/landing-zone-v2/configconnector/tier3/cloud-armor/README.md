# Cloud Armor

This example creates a Cloud Armor policy which can be later applied to targets (load balancer backend service).

[https://cloud.google.com/armor/docs/security-policy-overview](https://cloud.google.com/armor/docs/security-policy-overview)

## IAM
The following permissions are required on the project for the tier3-sa in order to manage policies:

```yaml
# iam-cloud-armor.yaml
# Grant GCP role Compute Security Admin to tier3-sa GCP SA for Cloud Armor
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: project-id-tier3-sa-computesecurityadmin-permissions # kpt-set: ${project-id}-tier3-sa-computesecurityadmin-permissions
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
spec:
  resourceRef:
    kind: Project
    external: projects/project-id # kpt-set: projects/${project-id}
  role: roles/compute.securityAdmin
  member: "serviceAccount:tier3-sa@project-id.iam.gserviceaccount.com" # kpt-set: serviceAccount:tier3-sa@${project-id}.iam.gserviceaccount.com
```
