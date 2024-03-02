# Single FortiGate VM
## How to deploy using gcloud

### Prerequisites
Before you deploy a FortiGate instance, you need to create
- 2 VPC Networks (external and internal)
- with 1 subnet in each

Note: subnets must be in the same region where you plan to deploy your FortiGate instance.

You also must know the following values:
1. URLs of external VPC and subnet
1. URLs of internal VPC and subnet
1. URL of image you're going to deploy (see [below](#how-to-find-the-image) for more details)
1. zone where you want to create your FortiGate VM

it's a good idea to save these values in shell variables. See the example below:

```
VPC_EXT_NAME=vpc-external
SB_EXT_NAME=sb-external-euwest1
VPC_INT_NAME=vpc-internal
SB_INT_NAME=sb-internal-euwest1

# find newest BYOL image
FGT_IMG_URL=$(gcloud compute images list --project fortigcp-project-001 --filter="name ~ fortinet-fgt- AND status:READY" --format="get(selfLink)" | sort -r | head -1)

ZONE=europe-west1-c
```

### Deploy
The commands below will deploy a FortiGate instance with 2 NICs, a 100GB logdisk and a single (ephemeral) external IP

```
# create log disk
gcloud compute disks create my-fgt-logdisk --size=100 --type=pd-ssd --zone=$ZONE

# create FortiGate instance
gcloud compute instances create my-fortigate --zone=$ZONE \
  --machine-type=e2-standard-2 \
  --image=$FGT_IMG_URL --can-ip-forward \
  --network-interface="network=$VPC_EXT_NAME,subnet=$SB_EXT_NAME" \
  --network-interface="network=$VPC_INT_NAME,subnet=$SB_INT_NAME,no-address"
  --disk="auto-delete=yes,boot=no,device-name=my-fgt-logdisk,mode=rw,name=my-fgt-logdisk"
```

To use a static EIP, create address as a separate resource and refer it when creating the FortiGate instance:

```
gcloud compute addresses create my-fortigate-eip --region=europe-west1

gcloud compute instances create my-fortigate --zone=$ZONE \
  --machine-type=e2-standard-2 \
  --image=$FGT_IMG_URL --can-ip-forward \
  --network-interface="network=$VPC_EXT_NAME,subnet=$SB_EXT_NAME,address=my-fortigate-eip" \
  --network-interface="network=$VPC_INT_NAME,subnet=$SB_INT_NAME,no-address"
  --disk="auto-delete=yes,boot=no,device-name=my-fgt-logdisk,mode=rw,name=my-fgt-logdisk"
```

Route traffic from internal VPC via FortiGate by creating a custom default route:
```
gcloud compute routes create default-via-my-fortigate \
  --network=$VPC_INT_NAME \
  --destination-range="0.0.0.0/0" \
  --next-hop-instance=my-fortigate \
  --next-hop-instance-zone=$ZONE \
  --priority=100
```

*Note:* by default, the internal VPC already includes a default route with priority 1000 via Default Internet Gateway. You must create a custom route with lower priority number or delete the built-in default route.

To make the traffic flow via FortiGate instance, you have to create Cloud Firewall rules that allow it:
```
gcloud compute firewall-rules create allow-external-to-fgt \
  --allow=all \
  --network=$VPC_EXT_NAME

gcloud compute firewall-rules create allow-internal-to-fgt \
  --allow=all \
  --network=$VPC_INT_NAME
```

*Complete example:*
```
VPC_EXT_NAME=vpc-external
SB_EXT_NAME=sb-external-euwest1
VPC_INT_NAME=vpc-internal
SB_INT_NAME=sb-internal-euwest1

# find newest BYOL image
FGT_IMG_URL=$(gcloud compute images list --project fortigcp-project-001 --filter="name ~ fortinet-fgt- AND status:READY" --format="get(selfLink)" | sort -r | head -1)

ZONE=europe-west1-c

# create log disk
gcloud compute disks create my-fgt-logdisk --size=100 --type=pd-ssd --zone=$ZONE

# create static external IP
gcloud compute addresses create my-fortigate-eip --region=europe-west1

#create FortiGate instance
gcloud compute instances create my-fortigate --zone=$ZONE \
  --machine-type=e2-standard-2 \
  --image=$FGT_IMG_URL --can-ip-forward \
  --network-interface="network=$VPC_EXT_NAME,subnet=$SB_EXT_NAME,address=my-fortigate-eip" \
  --network-interface="network=$VPC_INT_NAME,subnet=$SB_INT_NAME,no-address"
  --disk="auto-delete=yes,boot=no,device-name=my-fgt-logdisk,mode=rw,name=my-fgt-logdisk"

gcloud compute routes create default-via-my-fortigate \
  --destination-range="0.0.0.0/0" \
  --next-hop-instance=my-fortigate \
  --next-hop-instance-zone=$ZONE \
  --priority=100

gcloud compute firewall-rules create allow-external-to-fgt \
  --allow=all \
  --network=$VPC_EXT_NAME

gcloud compute firewall-rules create allow-internal-to-fgt \
  --allow=all \
  --network=$VPC_INT_NAME
```

### [optional] Additional external IP addresses

[Protocol Forwarding](https://cloud.google.com/load-balancing/docs/protocol-forwarding) is a GCP feature, which allows attaching additional external addresses to a VM. Before creating and attaching an address, a targetInstance resource must be created:

```
gcloud compute target-instance create my-fgt-target \
  --instance=my-fortigate --zone=$ZONE
```

Next, a forwarding rule can be added:
```
gcloud compute forwarding-rules create my-fwd-rule \
  --target-instance=my-fgt-target \
  --target-instance-zone=$ZONE \
  --ip-protocol=TCP \
  --ports=ALL
```

### SDN Connector account
If you plan to use dynamic address objects with SDN Connector please read also [this article](../../docs/sdn_privileges.md)

## How to find the image
You can either deploy one of the official images published by Fortinet or create your own image with disk image downloaded from [support.fortinet.com](https://support.fortinet.com). We recommend you use official images unless you need to deploy a custom image.

Fortinet publishes official images in *fortigcp-project-001* project. This is a special public project and every GCP user can list images available there using command

`gcloud compute images list --project fortigcp-project-001`

Official images for FortiGate have names starting with *fortinet-fgt-[VERSION]* (BYOL images) or *fortinet-fgtondemand-[VERSION]*. It is your responsibility to select the correct image if deploying using gcloud or templates (Deployment Manager templates in this repository automatically find image name based on version and licenses properties). Use filter and format options of gcloud command to get a clean list, eg.
`gcloud compute images list --project fortigcp-project-001 --filter="name ~ fortinet-fgtondemand AND status:READY" --format="get(selfLink)"`

will get you a list of image URLs for FortiGate PAYG, and

`FGT_IMG=$(gcloud compute images list --project fortigcp-project-001 --filter="name ~ fortinet-fgt- AND status:READY" --format="get(selfLink)" | sort -r | head -1)`

will save the URL of the newest BYOL image into FGT_IMG variable

## References
- [gcloud compute addresses create](https://cloud.google.com/sdk/gcloud/reference/compute/addresses/create)
- [gcloud compute disks create](https://cloud.google.com/sdk/gcloud/reference/compute/disks/create)
- [gcloud compute instances create](https://cloud.google.com/sdk/gcloud/reference/compute/instances/create)
- [gcloud compute routes create](https://cloud.google.com/sdk/gcloud/reference/compute/routes/create)
- [gcloud compute firewall-rules create](https://cloud.google.com/sdk/gcloud/reference/compute/firewall-rules/create)
- [Protocol Forwarding](https://cloud.google.com/load-balancing/docs/protocol-forwarding)
