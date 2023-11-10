# kcc-namespaces solution

## Description

This solution is a simple fork of the KCC Project Namespaces blueprint found at
<https://cloud.google.com/anthos-config-management/docs/tutorials/project-namespace-blueprint>

This simple solution will create a dedicated namespace to manage your GCP resources in a certain project. The namespace and project-id will be match for simplicity. This solution assumes that you storing all high-level resources in the `config-control` namespace.

Also, this solution grants the GCP Service Account that KCC uses to create resources in the tenant project the `Owner` role. This is a very broad role and it is recommend that you update the `kcc-project-owner.yaml` file to specify only the roles that are required to create the resources you wish. This will adopt the principal of least privilege.

## Usage

### **Fetch the package**

`kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/kcc-namespaces kcc-namespaces`

Details: <https://kpt.dev/reference/cli/pkg/get/>

### **View package content**

`kpt pkg tree kcc-namespaces`

Details: <https://kpt.dev/reference/cli/pkg/tree/>

### **Update and render package**

Update the setters.yaml file to match your environment then run
`kpt fn render kcc-namespaces`

Details: <https://kpt.dev/book/03-packages/04-rendering-a-package>

### **Apply the package**

```shell
kpt live init kcc-namespaces
kpt live apply kcc-namespaces --reconcile-timeout=2m --output=table
```

Details: <https://kpt.dev/reference/cli/live/>
