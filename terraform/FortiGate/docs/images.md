# How to find the VM image
When deploying instances using gcloud or templating tools, you have to provide a base VM image. You can either deploy one of the official images published by Fortinet or create your own image with disk image downloaded from [support.fortinet.com](https://support.fortinet.com). We recommend you use official images unless you need to deploy a custom image.

Fortinet publishes official images in *fortigcp-project-001* project. This is a special public project and every GCP user can list images available there using command

`gcloud compute images list --project fortigcp-project-001`

Official images for FortiGate have names starting with *fortinet-fgt-[VERSION]* (BYOL images) or *fortinet-fgtondemand-[VERSION]*. It is your responsibility to select the correct image if deploying using gcloud or templates (Deployment Manager templates in this repository automatically find image name based on version and licenses properties). Use filter and format options of gcloud command to get a clean list, eg.
`gcloud compute images list --project fortigcp-project-001 --filter="name ~ fortinet-fgtondemand AND status:READY" --format="get(selfLink)"`

will get you a list of image URLs for FortiGate PAYG, and

`FGT_IMG=$(gcloud compute images list --project fortigcp-project-001 --filter="name ~ fortinet-fgt- AND status:READY" --format="get(selfLink)" | sort -r | head -1)`

will save the URL of the newest BYOL image into FGT_IMG variable.

## Using terraform

You can use [fgt-get-image](../modules-tf/fgt-get-image) module to find the image. Simply run `terraform plan` or `terraform apply` in the module directory and provide your desired firmware version number. Optionally change architecture and licensing using `-var arch=arm` and `-var lic=byol` command line options respectively.

## Using image family
Starting from end of 2021 all newly published versions will support *image family* attribute. Using image family makes it easier to deploy the newest image of given product's major version, because you no longer need to list all available images to see what's available. Instead, you can simply say "deploy newest image of FortiGate 7.0". The image family name will consist of:

`[product name]-[major version without dot]-[licensing option (if available)]`

Image families available at the time of writing:
* fortigate-64-byol
* fortigate-64-payg
* fortimanager-70
* fortianalyzer-70
* fortigate-70-byol
* fortigate-70-payg
* fortigate-70 (DO NOT USE)
* fortigate-72-byol
* fortigate-72-payg
* fortigate-arm64-72-byol
* fortigate-arm64-72-payg
* fortigate-74-byol
* fortigate-74-payg
* fortigate-arm64-74-byol
* fortigate-arm64-74-payg

### Using image family with gcloud
```
gcloud compute instances create my-fortigate \
  --machine-type=e2-micro \
  --image-family=fortigate-74-byol --image-project=fortigcp-project-001 \
  --can-ip-forward \
  --network-interface="network=default"
```

### Using image family with Terraform
```
data "google_compute_image" "fgt_image" {
  project = "fortigcp-project-001"
  family  = "fortigate-74-byol"
}

resource "google_compute_instance" "my_fortigate" {
  name         = "my-fortigate"
  machine_type = "e2-micro"
  can_ip_forward = true

  boot_disk {
    initialize_params {
      image = data.google_compute_image.fgt_image.self_link
    }
  }

  network_interface {
    access_config {
    }
  }
}
```

### Using image family with Deployment Manager
```
resources:
- name: my-fortigate
  type: compute.v1.instance
  properties:
    zone: europe-west6-b
    machineType: zones/europe-west6-b/machineTypes/e2-micro
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: projects/fortigcp-project-001/global/images/family/fortigate-64-byol
        diskSizeGb: 10.0
    networkInterfaces:
    - network: global/networks/default
      accessConfigs:
      - name: External NAT
        type: ONE_TO_ONE_NAT
```
