# Fortigates

## Documentation

- [Fortigate - GCP Administration Guide](https://docs.fortinet.com/document/fortigate-public-cloud/7.2.0/gcp-administration-guide/736375/about-fortigate-vm-for-gcp)

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

```shell
gcloud compute images list --project fortigcp-project-001 --filter="name ~ fortinet-fgt- AND status:READY" --format="get(selfLink)"
```

## Known issues

- &#9744; GCP SDN connector not working. The connection is initiated from the fortigate mgmt interface. It requires access to the Google API public endpoint. The mgmt VPC has no route to the internet in order to meet security controls.
One option could be to :
  - create a PSC targeting "all-apis" on the internal VPC
  - create a dns zone for googleapis.com with a wildcard record that forwards the traffic to the PSC
  - establish VPC peering between mgmt and internal VPC
  - add a route for 0.0.0.0/0 on the mgmt VPC
  - create firewall rule allowing access from fortigate SA to PSC

    Once functional, Fortigate administrators have to add each project for which they want to see dynamic objects created to this section.

    ```fortios
      config system sdn-connector
          edit "gcp"
              set type gcp
              set ha-status enable
              config gcp-project-list
                  edit "project-id1"
                  next
                  edit "project-id2"
                  next
              end
          next
      end
    ```

## Optional - possible future enhancements

### GCP

- &#9744; VM image with guest os feature [MULTI_IP_SUBNET](https://docs.fortinet.com/document/fortigate-public-cloud/7.2.0/gcp-administration-guide/187414/multi-ip-subnet-scheme)

- &#9744; Performance tuning - enable [dpdk](https://docs.fortinet.com/document/fortigate-public-cloud/7.2.0/gcp-administration-guide/214328/google-cloud-dpdk-support)

- &#9744; ERROR - Performance tuning - VM image with guest os feature [gVNIC](https://docs.fortinet.com/document/fortigate-public-cloud/7.2.0/gcp-administration-guide/967571/deploying-a-gvnic-interface)

    ```shell
    gcloud compute --project=dldmu-dl-hub2 images create gcp-ond-722-gvnic --source-image=fortinet-fgtondemand-722-20221004-001-w-license --source-image-project=fortigcp-project-001 --guest-os-features=GVNIC

    ERROR: (gcloud.compute.images.create) Could not fetch resource:
    - Location us violates constraint constraints/gcp.resourceLocations on the resource projects/dldmu-dl-hub2/global/images/gcp-ond-722-gvnic.
    ```

- &#9744; instance schedule for fortigates and management vm. This would allow non-prod environment to define a start and stop time for each instance. One use case could be to have the primary fortigate running all the time but have the secondary fgt only running ~20 minutes per day to allow config synchronization.
- &#9744; remove static ip and use dhcp...knowing that ip are assigned in GCP
- &#9744; deploy instances from instance templates.

### KPT Setters

- &#9744; the following parameters are currently embedded into the fortigate config (GCE metadata). it would be great if they could be customized with setters.
  - &#9744; fortigate timezone
  - &#9744; fortigate ha pw
