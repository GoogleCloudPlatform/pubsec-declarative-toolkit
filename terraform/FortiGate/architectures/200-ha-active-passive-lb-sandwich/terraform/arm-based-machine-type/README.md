# Module feature: ARM-based machine types

Google Cloud offers machine types based on Intel, AMD and ARM processors. ARM architecture is supported by FortiGate since version 7.2.4 and can be deployed using this module.

***NOTE:*** *make sure T2A family machine types are available in your region*

## Configuration

Deploying an ARM-based instance requires
- boot image supporting ARM architecture
- machine type from T2A family
- using GVNIC network driver (VIRTIO is not supported by T2A machine type family)

Above requirements can be configured by passing the following variables to the module:

```
image_family  = "fortigate-arm64-72-payg"
machine_type  = "t2a-standard-4"
nic_type      = "GVNIC"
```

or when it's desired to deploy a particular version instead of the latest one:

```
image_name    = "fortinet-fgt-arm64-724-20230216-001-w-license"
machine_type  = "t2a-standard-4"
nic_type      = "GVNIC"
```
