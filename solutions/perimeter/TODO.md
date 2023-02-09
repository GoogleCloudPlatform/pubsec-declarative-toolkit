# TODO list

## GCP

- &#9745; add org policy exception for vm with public ip AND serial console access
- &#9745; fortigate license:
    --metadata-from-file "license=<license text file>,user-data=<FortiGate CLI text file>". In this example, it will be --metadata-from-file "license=license.txt,user-data=config.txt".

---

## Fortigate

- &#9745; add route for ip range of all peered vpc (ex. : 10.0.0.0/8) and define the internal gateway ip (ex. : 172.31.201.1) as the gateway

- &#9745; update time zone to be gmt-5

- &#9745; explicit proxy - required for apprz and datarz workloads

- &#9744; ERROR - GCP SDN connector not working
    ```
    # debug logs from fortigate
    GCP guest environment update
    GCP update done
    In HA primary state
    gcpd config not found.
    gcpd curl error:28
    gcpd sdn connector gcp get zones list failed
    gcpd reap child pid: 3953
    exec pgcpd sdn connector gcp prepare to update
    gcpd get token
    gcpd metadata url: http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token
    gcpd metadata result:200
    Token expires in: 2095 seconds
    gcpd metadata url: http://169.254.169.254/computeMetadata/v1/project/project-id
    gcpd metadata result:200
    gcpd got project id from metadata: dldmu-dl-perimeter2
    gcpd sdn connector gcp start updating
    gcpd sdn connector gcp got empty project list, trying sdn update from metadata project: dldmu-dl-perimeter2
    ```
- &#9744; Fortigate HA is not synchronising secondary ip of interfaces. Meanwhile, secondary ip have to be configured on both fortigates.


## KPT Setters :
- &#9745; fortigate images (primary and secondary,, in case you want to run your primary with a license and the secondary with PAY-AS-YOU-GO)
- &#9744; the following parameters are currently embedded into the fortigate config (GCE metadata). it would be great if they could be customized with setters.(maybe use ConfigMap, GCP secret manager/Kubernetes secrets)
  - &#9744; fortigate timezone
  - &#9744; fortigate admin pw
  - &#9744; fortigate ha pw
  - &#9745; licenses [license](https://docs.fortinet.com/document/fortigate-public-cloud/7.2.0/gcp-administration-guide/766352/licensing)

---
## Optionnal - possible future enhancements
- &#9744; VM image with guest os feature [MULTI_IP_SUBNET](https://docs.fortinet.com/document/fortigate-public-cloud/7.2.0/gcp-administration-guide/187414/multi-ip-subnet-scheme)

- &#9744; Performance tuning - enable [dpdk](https://docs.fortinet.com/document/fortigate-public-cloud/7.2.0/gcp-administration-guide/214328/google-cloud-dpdk-support)

- &#9744; ERROR - Performance tuning - VM image with guest os feature [gVNIC](https://docs.fortinet.com/document/fortigate-public-cloud/7.2.0/gcp-administration-guide/967571/deploying-a-gvnic-interface)

    ```bash
    gcloud compute --project=dldmu-dl-perimeter2 images create gcp-ond-722-gvnic --source-image=fortinet-fgtondemand-722-20221004-001-w-license --source-image-project=fortigcp-project-001 --guest-os-features=GVNIC
    
    ERROR: (gcloud.compute.images.create) Could not fetch resource:
    - Location us violates constraint constraints/gcp.resourceLocations on the resource projects/dldmu-dl-perimeter2/global/images/gcp-ond-722-gvnic.
    ```
- &#9744; instance schedule for fortigates and management vm. This would allow non-prod environment to define a start and stop time for each instance. One use case could be to have the primary fortigate running all the time but have the secondary fgt only running ~20 minutes per day to allow config synchronisation.
- &#9744; remove static ip and use dhcp...knowing that ip are assigned in GCP
- &#9744; deploy instances from instance templates.

## Out of scope
1. post-deployment configuration
1. sending logs to external system
1. fortigate monitoring