# Fortigates

## Performance tuning 

- [gVNIC](https://docs.fortinet.com/document/fortigate-public-cloud/7.2.0/gcp-administration-guide/967571/deploying-a-gvnic-interface)

- [dpdk](https://docs.fortinet.com/document/fortigate-public-cloud/7.2.0/gcp-administration-guide/214328/google-cloud-dpdk-support)

## Images

In order to deploy VM instances you need to use base FortiGate image. Fortinet published set of images
which can be used by any Google Cloud user in fortigcp-project-001. You can find there image for
a specific version you want to use (the example script below selects the last BYOL image). If you do
not need to use a specific version you can use image family to let the cloud find the newest image
automatically.

It is important to select image associated with your desired licensing (PAYG or BYOL). PAYG image names start with "fortinet-fgtondemand".

Available image families:
- fortigate-64-byol - newest BYOL image ver. 6.4.*
- fortigate-64-payg - newest PAYG image ver. 6.4.*
- fortigate-70-byol - newest BYOL image ver. 7.0.*
- fortigate-70-payg - newest PAYG image ver. 7.0.*

To find image for specific version use command like below
```
gcloud compute images list --project fortigcp-project-001 --filter="name ~ fortinet-fgt- AND status:READY" --format="get(selfLink)"
```
