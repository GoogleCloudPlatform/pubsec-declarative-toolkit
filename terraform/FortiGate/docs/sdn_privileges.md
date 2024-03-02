# Privileges required by SDN Connector (for dynamic addresses)

FortiGate SDN Connector can be used to pull information from the cloud intrastructure and enable use of dynamic address objects in firewall policy. In order to make it work you have to either provide the instance with service account key file (works also outside of Google Cloud) or associate an instance running in GCE with a service account and let the SDN connector pull the key from metadata server. In both cases you have to create a Service Account in your project and assign it the proper set of privileges grouped in a Role.

By default, any new VM created in Google Cloud gets associated with the Default Compute Engine service account. It is one of the built-in service accounts, which by default has very broad privileges (Project Owner role) and it is recommended by Google to reassign privileges to it when ready. Also, the Default Compute Engine account is using legacy roles, which require combining it with a proper scope. The default scope does not include Compute API, which means - it will not work for SDN Connector. New generation of IAM roles offer much more precise privilege set and do not require combining with scope.

In order to follow the least privilege principle it is recommended to create a dedicated role and a service account with only the privileges required for SDN to work.

### Creating a role
IAM privileges are very precise and usually performing some task requires set of several privileges. Such sets are grouped in so-called Roles. You can create a role using web console or the gcloud command-line tool:
```
GCP_PROJECT_ID=$(gcloud config get-value project)

gcloud iam roles create FortigateSdnReader --project=$GCP_PROJECT_ID \
  --title="FortiGate SDN Connector Role (read-only)" \
  --permissions="compute.zones.list,compute.instances.list,container.clusters.list,container.nodes.list,container.pods.list,container.services.list"
```

### Creating a service account
After the role is created it can be assigned to a Service Account. The commands below will create a new Service Account and assign it to a proper Role within your current project:
```
gcloud iam service-accounts create fortigatesdn-ro \
  --display-name="FortiGate SDN Connector"

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
  --member="serviceAccount:fortigatesdn-ro@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
  --role="projects/$GCP_PROJECT_ID/roles/FortigateSdnReader"
```

Service accounts are created in a project, but can be given access to multiple other projects. FortiGate now supports using a single SDN connector (using a single service account) for multiple projects simplifying configuration of both the firewall and the cloud IAM.

### Assigning service account to a VM instance
Once you have the Service Account ready you can assign it to your FortiGate VM instance. You can do it when creating the instance or afterwards, but keep in mind changing assigned service account requires stopping the VM instance. You can easily change the account in Web UI, but you cannot assign it when deploying from the Marketplace. To assign your custom service account during deployment you have to use gcloud, Deployment Manager or Terraform.

#### gcloud
```
gcloud compute instances create my-fortigate \
[...]
 --service-account=fortigatesdn-ro@$GCP_PROJECT_ID.iam.gserviceaccount.com \
 --scope=cloud-platform
```

#### Deployment Manager
```
- name: my-fortigate
  type: compute.v1.instance
  properties:
    [...]
    serviceAccounts:
    - email: fortigatesdn-ro@MY_PROJECT_ID.iam.gserviceaccount.com
      scopes:
      - 'https://www.googleapis.com/auth/cloud-platform'
```

#### Terraform
```
resource "google_compute_instance" "my-fortigate" {
  name         = "my-fortigate"
  [...]
  service_account {
    email = "fortigatesdn-ro@MY_PROJECT_ID.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
```

#### FortiGate configuration for SDN Connector
SDN Connector can be defined using GUI or on command line. When configuring it on a virtual FortiGate running in GCP with a Service Account assigned as described above, it is recommended to select "Use metadata IAM" option to automatically pull temporary access token from the cloud metadata server.

```
config system sdn-connector
  edit gcp-connector
    set type gcp
  next
end
```

### Using the service account in a FortiGate outside GCE
FortiGates running outside of Google Cloud cannot access their metadata services and need to be provided with service account key to properly authenticate against Google APIs. To create and download a key:
1. go to "*IAM & Admin*" > "*Service accounts*"
1. open the multi-dot for your service account and choose "*Manage keys*"
1. create a new private key and download it in JSON format
1. extract the private key from JSON file - eg. using `cat key.json | jq -r ".private_key" | sed -e 's/\\n/\n/g'` (use `gsed` on MacOS)
1. paste the private key to FortiGate when configuring the SDN Connector

### Troubleshooting
For troubleshooting SDN connector follow the official Administration Guide article [here](https://docs.fortinet.com/document/fortigate-public-cloud/7.0.0/gcp-administration-guide/884509/troubleshooting-gcp-sdn-connector)
