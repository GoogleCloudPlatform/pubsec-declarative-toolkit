# Bastion Host Service

## Description
This service will generate a bastion host VM compatible with OS Login, IAP Tunneling and OS Configuration Management that can be used to access internal VMs and / or private GKE clusters.

This service will create an OS Configuration Management policy to install some default apps like:

- kubectl
- docker
- kpt

If you wish you can edit the os-config.yaml file to add / remove any software you may need to be pre-installed on the bastion host. OS Config Policy Assignment specs can be found here: https://cloud.google.com/config-connector/docs/reference/resource-docs/osconfig/osconfigospolicyassignment

## Usage

### **Fetch the package**
`kpt pkg get git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git/services/bastion-host@main bastion-host`

Details: https://kpt.dev/reference/cli/pkg/get/

### **View package content**
`kpt pkg tree bastion-host`

Details: https://kpt.dev/reference/cli/pkg/tree/

### **Update and render package**
This services uses 2 files for templating:
- Update the setters.yaml file to meet your environment specs
- Update the fn-namespaces.yaml, namespace: field to match the KCC namespace that the resources should be created in. If you are using the default config-control KCC namespace then you can ignore this file.

`kpt fn render bastion-host`

Details: https://kpt.dev/book/03-packages/04-rendering-a-package

### **Apply the package**
```
kpt live init bastion-host
kpt live apply bastion-host --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/