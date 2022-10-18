# PBMM Landing Zone Architecture


## Purpose
Create, manage and operate a PBMM secure landing zone for the Google Cloud Environment. 
This project details the architecture for a mult-tenant Landing Zone as a Service - where multiple deptartments and workloads deploy under a shared organization with TBD folder separation.

### Why Landing Zones
Expand on https://cloud.google.com/architecture/landing-zones/decide-network-design#option-2 in https://cloud.google.com/architecture/landing-zones#what-is-a-google-cloud-landing-zone

## Artifacts
### Google Cloud Architecture Slides
Google Cloud Architecture slides templates - https://cloud.google.com/icons specifically the Google Slides tempate for 2022 in https://docs.google.com/presentation/d/1fD1AwQo4E9Un6012zyPEb7NvUAGlzF6L-vo5DbUe4NQ/edit. 
We will keep the source for the diagrams in an invite-only shared folder at https://docs.google.com/presentation/d/19B3gdZ1ukrRekEFQ1UIWsZJJi4ElABzziKEkPnS54uI/edit#slide=id.gff25b70edb_0_0

## Deliverables
### SC2G Deliverables
#### CDD: Conceptual Design Document
High leve applications and interconnections through the SC2G infrastructure.  Include examples of PaaS, SaaS, IaaS and hybrid applications.

#### SID: Solution Integration Document
This document details the connections, devices, network segments, zones, hostnames, ports, IPS of a particular application - usually worked out with the team implementing a particular workload.  The diagram centers on the GC-TIP and GC-CAP connections.

#### WIF: Workload Intake Form
A spreadsheet of cloud ingress/egress application flows with an implementation diagram.





## Architecture

### Diagrams
#### Low Level Zoning Diagram
![img](img/_landingzone_system_comm_description.png)
#### High Level Network Diagram
- Common Services Project - and "Shared Services", "SharedInfrastructure" - in the high level network diagram - https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/dev/solutions/landing-zone/architecture.md#high-level-network-diagram - the common services project contains services like SSO, backup, IAP and any CI/CD infrastructure that would be common to a cross section of the workloads projects.  I will adjust the diagram to rename it "shared services".  A subset may reside in "SharedInfrastructure" depending on how we partition between a service and deployment infrastructure
![img](img/_landingzone-high-level-op-concept.png)

![img](img/_landingzone_system_interface_description.png)

### Naming Standard
We have the design issue in the queue.  The original TF LZ had parts of the proposed standard but several of the schema attributes are distributed among the tfvars with some 1-off duplication.
We can work out the KCC standard as we go using as reference in DI-09
- https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/dev/solutions/landing-zone/architecture.md#di-09-naming-standard
- see
- https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/130
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/132
- see SSC naming/tagging doc reference https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/182


### Organization and Folder Structure
  The folder structure proposed as an example to an evolving devops architecture that will attempt to satisfly the following constraints, requirements and SLO's
  - these are evolving...
  - day 1 operations - deployment
  - day 2 operations - team deployment ops
  - single or multi-tenant organization infrastructure (including vpc peering between orgs)
  - classified and unclassified workloads and separation
  - CI/CD pipelines for dev/stg/uat/prod
  - sandbox (out of band) adhoc projects (usually unclassified)
  - hierarchical config/security override structure via folder tree
  
  
 I will put up a revised diagram for the KCC LZ - the structure is close to the original TF LZ but I expect us to evolve it.
 
 <img width="1223" alt="Screen Shot 2022-10-05 at 8 35 48 AM" src="https://user-images.githubusercontent.com/94715080/194061583-738201a4-c220-44f9-be28-809ec668bda4.png">

  

 Some of our architectural docs are being developed here in the PDT repo in a just-in-time manner, other parts are the result of TF transfer or reverse engineering.  The folder diagram has aspects of this. 
 see the original TF structure at https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/environments/common/common.auto.tfvars#L35
 ```
 20221004
   names  = ["Infrastructure", "Sandbox", "Workloads", "Audit and Security", "Automation", "Shared Services"] # Production, NonProduction and Platform are included in the module
  subfolders_1 = {
    SharedInfrastructure = "Infrastructure"
    Networking           = "Infrastructure"
    Prod                 = "Workloads"
    UAT                  = "Workloads"
    Dev                  = "Workloads"
    Audit                = "Audit and Security"
    Security             = "Audit and Security"
  }
  subfolders_2 = {
    ProdNetworking    = "Networking"
    NonProdNetworking = "Networking"
  }
}
 ```
 see the evolving KCC structure at https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/solutions/landing-zone/environments/common/hiearchy.yaml#L27
 ```
 20221004
   config:
    - Infrastructure:
        - Networking:
            - ProdNetworking
            - NonProdNetworking
        - SharedInfrastructure
    - Sandbox
    - Workloads:
        - Prod
        - UAT
        - DEV
    - "Audit and Security":
        - Audit
        - Security
    - Automation
    - "Shared Services"
 ```
 
#### Folder Structure Design Notes
- Sandbox: this folder is an out of band folder for use by unclassified experimental workloads that may need overrides outside of the normal workloads folder - it may be folded into the workloads folder though.
- Automation: Tentatively reserved for workload targetted continuous deployment pipelines work to start - however CD pipelines may still be workload folder specific
- Common Services Project - and "Shared Services", "SharedInfrastructure" - in the high level network diagram - https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/dev/solutions/landing-zone/architecture.md#high-level-network-diagram - the common services project contains services like SSO, backup, IAP and any CI/CD infrastructure that would be common to a cross section of the workloads projects.  I will adjust the diagram to rename it "shared services".  A subset may reside in "SharedInfrastructure" depending on how we partition between a service and deployment infrastructure


  
### Deployed Project Structure

<img width="1290" alt="Screen Shot 2022-09-15 at 10 46 44" src="https://user-images.githubusercontent.com/24765473/190434889-ff2fab6a-e705-46b9-8400-19e86a8419d9.png">



### Backups
Trusted image policies can be setup using organization policies in IAM - see https://cloud.google.com/compute/docs/images/restricting-image-access
GCP services configurations and snapshots can be configured for scheduled automated snapshots to Google Cloud Storage using four tiers of short to long term storage.

Notes:
define a naming standard and schedule for automated snapshots 

### Configuration Management
All services, roles and artifacts inside the GCP organization are tracked in IAM Asset Inventory and Security Command Center - both change tracking.

### Logging
[Logging](https://console.cloud.google.com/logs) (part of the [Cloud Operations Suite](https://cloud.google.com/products/operations)) has its own dashboard.
The logging agent (ops - based on FluentD / OpenTelemetry) is on each VM - out of the box it captures OS logs (and optionally - application logs - which is configurable in the agent).  Log sources include service, vm, vpc flow and firewall logs.

#### Log Sinks
Google Cloud Logs can be routed using log sinks (with optional aggregation) to destinations like Cloud Storage (object storage), PubSub (message queue) or BigQuery (serverless data warehouse) with 4 levels of tiering for long term storage or auditing.

#### Audit Logging Policy
GCP provides for audit logging of admin, data access, system event and policy denied logs for the following [services](https://cloud.google.com/logging/docs/audit/services) - in addition to [access transparency logs](https://cloud.google.com/logging/docs/view/available-logs). Redacted user info is included in the audit log entries.  

### Network Zoning
Ref: ITSG-22: https://cyber.gc.ca/sites/default/files/cyber/publications/itsp80022-e.pdf - see ZIP (Zone Interface Points)
Ref: https://cloud.google.com/architecture/landing-zones

  The GCP PBMM Landing Zone architecture provides an automated and pluggable framework to help secure enterprise workloads using a governance model for services and cost distribution.

  The network zoning architecture is implemented via virtual SDN (software defined networking) in GCP via the [Andromeda framework](https://cloud.google.com/blog/products/networking/google-cloud-networking-in-depth-how-andromeda-2-2-enables-high-throughput-vms).  Physical and virtual zoning between the different network zones is the responsibility of GCP.  The physical networking and hosting infrastructure within and between the two canadian regions is the responsibility of GCP as per [PE-3](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-security-controls.md#3830pe-3physical-access-control)

  This PBMM architecture supports all the common network level security controls that would be expected within a zoned network around routing, firewall rules and access control.  The GCP PBMM Landing Zone will support the ITSG-22 Baseline Security Requirements for Network Security Controls.  Information flow is controlled between each network segment/zone via VPC networks, VPC Service Controls, Shared VPCs or VPC Peering for network connections.  The network design currently includes a PAZ/Perimeter public access zone/VPC, a management zone on the perimeter, an internal production zone in either shared VPC for PaaS workloads or Peered VPC for IaaS workloads.  As part of the PAZ/Perimeter zone we deploy a Fortigate cluster between a front facing L7 public load balancer and an internal L7 private load balancer.  All messaging traverses the PAZ where the Fortigate cluster packet inspects ingress and egress traffic.  GCP deploys Cloud Armor in front of the PAZ zone for additional default protection in the form of ML based L7 DDoS attack mitigation, OWASP top 10, LB attacks and Bot management via reCAPTCHA  
  
  All ingress traffic traverses the perimeter public facing Layer 7 Load Balancer and firewall configured in the Perimeter project/VPC.  All egress internet traffic is packet inspected as it traverses the Firewall Appliance cluster in the perimeter VPC. All internal traffic inside the GCP network is default encrypted at the L3/L4 level. Public IP’s cannot be deployed in the client/workload VPC’s due to deny setting in the “Define allowed external IPs for VM instances” IAM Organization Policy.  Public IP's are only permitted specifically in the public perimeter VPC hosting the public facing L7 Load Balancer in front of the Firewall Appliance cluster. 
  All network operations are centrally managed by the customer operations team on a least privilege model - using the GCP Cloud Operations Suite in concert with IAM accounts and roles.
  Logging and network event monitoring are provided by the centralized GCP Logging Service and associated Log Agents.


### Vulnerability Management
#### Container Analysis

Static analysis of container images is provided by [Artifact Registry](https://cloud.google.com/artifact-registry/docs/analysis) | Container Analysis and Vulnerability Scanning - including automatic [Vulnerability Scanning](https://cloud.google.com/container-analysis/docs/os-overview) (per container image build)  

#### Cloud Armor
Proactive threat detection also occurs at the perimeter of customer networks via Cloud Armor https://cloud.google.com/armor.  Google Cloud Armor provides DDoS (Distributed Denial of Service) and WAF (Web Application Firewall) protection in addition to Bot, OWASP and adaptive ML based layer 7 DDoS capabilities.   Cloud Armor integrates with our Cloud CDN and Apigee API Management front end services.  Detection can be customized by adding rules - the following is in place by default
- ML based layer 7 DDoS attacks
- OWASP top 10 for hybrid
- Load Balancer attacks
- Bot management via reCAPTCHA 

GCP Compute and GKE (Google Kubernetes Engine) benefit from secure [Shielded VMs](https://cloud.google.com/shielded-vm)

#### Intrusion Detection System
GCP IDS (Intrusion Detection System Service) (based on the Palo Alto security appliance) - https://cloud.google.com/intrusion-detection-system handles Malware, Spyware and Command-and-Control attacks. Intra- and inter-VPC communication is monitored. Network-based threat data for threat investigation and correlation can be generated including intrusion tracking and response.

In addition for Chrome based clients we have BeyondCorp zero trust capabilities.

#### Security Command Center
Security Command Center Premium includes Vulnerability scanning, Findings, Container Threat Detection, Event Threat Detection, Virtual Machine Threat Detection, Web Security Scanner - application discovery/scanning
Security Command Center Premium - Threat Detection - https://cloud.google.com/security-command-center/docs/concepts-event-threat-detection-overview detects threats using logs running in Google Cloud at scale including container attacks involving suspicious binary, suspicious library, and reverse shell vectors.

GCP provides trusted image scanning to reject unsanctioned public image downloads through a organizational policy called trusted image policy https://cloud.google.com/compute/docs/images/restricting-image-access 

## Operations
### Allowlist
Allowlists are defined by workload and security profile.  Dev may have cloud-internet egress all the way to 0.0.0.0/0.
### Denylist


## Security Controls
- see ITSG-33 [Scurity Controls Mapping](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-security-controls.md) 

### Compliance
- Forseti : https://opensource.google/projects/forsetisecurity
### References
- https://www.googlecloudcommunity.com/gc/Public-Sector-Connect/ct-p/public-sector-connect
- https://cloud.google.com/blog/topics/public-sector/meet-canadian-compliance-requirements-protected-b-landing-zones
- https://cloud.google.com/security/compliance/offerings#/regions=Canada
- SCED (SC2G) connection patterns - slide 18/19 for cloud profiles 1 to 6 https://wiki.gccollab.ca/images/7/75/GC_Cloud_Connection_Patterns.pdf
- CCCS PBMM ITSG-33 Annex 4A Profile 1 https://cyber.gc.ca/sites/default/files/cyber/publications/itsg33-ann4a-1-eng.pdf from https://cyber.gc.ca/en/guidance/annex-4a-profile-1-protected-b-medium-integrity-medium-availability-itsg-33
- Google Architecture Center - Security Blueprints - https://cloud.google.com/architecture/security-foundations 
- Google infrastructure security design overview  https://cloud.google.com/docs/security/infrastructure/design
- Workspace - https://cloud.google.com/blog/topics/public-sector/google-workspace-earns-dod-il4-authorization
- Workspace Guardrails Repo - https://github.com/canada-ca/cloud-guardrails-workspace
- Cloud Logging Compliance = https://cloud.google.com/blog/products/identity-security/5-must-know-security-and-compliance-features-in-cloud-logging
- FedRamp High (see ITSG-33) GCP services - https://cloud.google.com/security/compliance/fedramp
- NIST Cybersecurity Framework & Google Cloud 202204 - https://services.google.com/fh/files/misc/gcp_nist_cybersecurity_framework.pdf
- https://www.canada.ca/en/government/system/digital-government/government-canada-digital-operations-strategic-plans/canada-digital-ambition.html
- SSC Public Cloud DNS - https://ssc-clouddocs.canada.ca/s/dns-ground-to-public-article?language=en_US






# Onboarding
[GCP Cloud Identity Onboarding](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md)

## Client Classifications
## Onboarding a Tier 1 Client

# Developer Operations

# Developer Tools
- Architecture
  - Centralized Network Appliances on Google Cloud : https://cloud.google.com/architecture/architecture-centralized-network-appliances-on-google-cloud
- Config Connector
  - Mutlirule Security Policy : https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computesecuritypolicy#multirule_security_policy
- KPT
- https://kpt.dev/book/07-effective-customizations/01-single-value-replacement
- GKE - Deploy multi-cluster Gateways : https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-multi-cluster-gateways#capacity-load-balancing
- Logging
  - Configure aggregated Sinks : https://cloud.google.com/logging/docs/export/aggregated_sinks#api
- OAuth 2.0
  - OpenID Connect : https://developers.google.com/identity/protocols/oauth2/openid-connect 
- Prow : https://prow.k8s.io/command-help
- VPC
  - Secure data exchange with ingress and egress rules : https://cloud.google.com/vpc-service-controls/docs/secure-data-exchange




# Design Issues

pending
- 20220923: adjust billing text in https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/dev/solutions/landing-zone#kpt

## DI-01: ITSG-33 PBMM Security Controls
[#145](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/145)
## DI-05: Complete Network Design
see [VPC Peering](#di-20-separate-vpc-per-cloud-profile-356-workloads)
The networking side will be undergoing a lot of changes starting with initial peering and zoning for both shared and non-shared VPC config to make it usable.
- [Networking Filter](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/labels/Networking)
- https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/78
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/149
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/45
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/architecture.md#di-6-landing-zone-network-topology-design
- see overall TF to KCC migration https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/124

### Network Architecture Patterns Available
- Criteria: SC2G, multi-nic/Appliances bridging VPC's, prod/non-prod network/zone separation
- We will go over the following network designs and come up with an aggregate that works for the landing zone
- GCP Architecture: Option 2: Hub-and-spoke topology with centralized appliances https://cloud.google.com/architecture/landing-zones/decide-network-design#option-2from https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/architecture.md#why-landing-zones 
- (with gconsole deployment example) GCP Architecture: Deploying centralized VM-based appliances using VPC network peering https://cloud.google.com/architecture/deploying-nat-gateways-in-a-hub-and-spoke-architecture-using-vpc-network-peering-and-routing?hl=en off https://cloud.google.com/architecture/architecture-centralized-network-appliances-on-google-cloud
- Fortinet specific: https://github.com/40net-cloud/fortinet-gcp-solutions/tree/master/FortiGate/architectures and https://github.com/fortinetsolutions/terraform-modules/tree/master/GCP/examples/ha-active-passive

### 20221018 Network Appliance Design

## DI-07: CD Canary Workload for deployment verification
[#182](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/82)
The LZ as-is (mostly still in line with the terraform original) has not actually been used yet for a canary workload until at least peering is added between the shared host VPC and the perimeter VPC, fw rules are set, routes are verified. 
Putting the LZ to use is next in the queue - as traffic generation to exercise the log/alert/metrics system has only been done outside of the project set so far.


## DI-08: Multitenancy
For multiple LZ's - there is a requirement for multi-tenancy - this can be done by separate subdomain orgs (These would need their own lz and VPC cross org peering) - this is out of scope for now.  The design pattern for multi-tenancy will likely be **folder** based in a single org. 
So one LZ for all teams - will have to determine how this works with LZ upgrades... blast radius

## DI-09: Naming Standard
- see https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/dev/solutions/landing-zone/architecture.md#naming-standard
- see https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/130
- see SSC naming/tagging doc reference https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/182
- Follow https://cloud.google.com/architecture/best-practices-vpc-design#naming

### Discussion
The current naming standard in the PBMM LZ keys off the constraints in https://cloud.google.com/resource-manager/docs/creating-managing-projects
- There are the GCP limitations around the naming standard (30 char,...) to start. - from the blueprints repo link to ACM docs
https://cloud.google.com/anthos-config-management/docs/tutorials/landing-zone#setting_up_your_resource_hierarchy and back to the constraint example
https://github.com/GoogleCloudPlatform/blueprints/blob/main/catalog/hierarchy/simple/policies/naming-constraint.yaml#L26
- Which requires our naming strategy population
https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/solutions/landing-zone/environments/common/general-policies/naming-rules/constraint.yaml#L26 based on the rules in https://cloud.google.com/resource-manager/docs/creating-managing-projects


We have multiple optional dept/domain/org id;s throughout
(org)-(domain)-(env = prod/stg..)-vpc

see ongoing TF naming standard discussion we are bring over here in https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/132

### Pros/Cons

### Decision
- GCP service wide naming strategy to be determined


## DI-10: L7 Packet Inspection required
## DI-12: Workload separation
## DI-13: Centralized IP space management
## DI-14: Security Command Center
Security Command Center (Standard and Premium) is what Google uses to secure Google.
## DI-15: IP Addressing vi RFC 1918/RFC 6598 Addressing, ground and cloud zoning
## DI-16: Validate DNS flows for bidirectional cloud to ground
## DI-17: GC-CAP infrastructure - Internet to Cloud
## DI-18: GC-TIP infrastructure - Ground to Cloud
Including [GCP Dedicated Interconnect](https://cloud.google.com/network-connectivity/docs/interconnect/concepts/dedicated-overview) and IPSEC / MACSEC [VPN](https://cloud.google.com/network-connectivity/docs/vpn/concepts/overview)
## DI-19: Bastion Access per security zone
- IAP and private connect
## DI-20: Separate VPC per Cloud Profile 3/5/6 workloads
- https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/78
- see see [Complete Network Design](#di-05-complete-network-design)
- see slide 18 of https://wiki.gccollab.ca/images/7/75/GC_Cloud_Connection_Patterns.pdf
- Since profile 3 and 6 access the PAZ (GC-CAP) and profile 5 is restricted to the RZ (GC-TIP) - profile 3 does not use GC-TIP for SC2G. The security appliance setup for GC-TIP is therefore restricted to 5 and 6, but the security appliance(s) used for GC-CAP can be shared.  Need to operationally verify this

### VPC Peering
VPC peering for hub and spoke vs Shared VPC - in terms of workload separation.
Expand on https://cloud.google.com/architecture/landing-zones/decide-network-design#option-2 in https://cloud.google.com/architecture/landing-zones#what-is-a-google-cloud-landing-zone



Uncomment and KPT render each peer pair in
https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/solutions/landing-zone/environments/common/network/network-peering.yaml#L15
#### Issues
GCP has a default limit of 25 to AWS limit of 50 VPC peering connections - see p. 138 of the "Google Cloud Cerfified: [Professional Cloud Architect Study Guide](https://www.google.ca/books/edition/Google_Cloud_Certified_Professional_Clou/3YJlEAAAQBAJ?hl=en&gbpv=1&dq=Professional+Cloud+Architect+Study+Guide&printsec=frontcover)"

#### Prototyping

Move example peering on the TF side to the KCC side
https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/146
https://console.cloud.google.com/networking/peering/list?orgonly=true&project=ospe-obs-obsprd-obspubper&supportedpurview=project

```
perimeter-networ-auto.tfvars
21
      peer_project                           = "ospe-obs-obsprd-obshostproj9" # Production Host Project Name
      peer_network                           = "ospecnr-prodvpc-vpc" # Production VPC Name
prod-network-auto.tfvars

      peer_project                           = "ospe-obs-obsprd-obspubper" # see perimeter-network
      peer_network                           = "ospecnr-obspripervpc-vpc" # private not ha
```

org a- gcp.obrien.services 
https://console.cloud.google.com/networking/peering/list?orgonly=true&project=ospe-obs-obsprd-obspubper&supportedpurview=project

<img width="1577" alt="Screen Shot 2022-10-07 at 10 42 21 AM" src="https://user-images.githubusercontent.com/94715080/194580619-6690a1e7-dfcb-470d-9987-aae7099020d7.png">
#### Alternatives
Investigate alternatives like VPN tunnelling (essentially GC-TIP but internal).  Looks at above L4 network separation via namespaces (K8S to start).
Look at verifying that the shared VPC model (analog to the Transit Gateway from 2019) does not have network separation even though we can use 1:1 project/subnet pairing as an alternative.
#### Decision


#### Links
- AWS = 50 (modifiable)
- https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-quotas.html
- https://us-east-1.console.aws.amazon.com/servicequotas/home/requests
- GCP = 25 (modifiable)
- https://cloud.google.com/vpc/docs/quota?hl=en_US&_ga=2.238983808.-1098396564.1647194753#vpc-peering
- see p65 of https://www.google.ca/books/edition/Google_Cloud_Certified_Professional_Clou/HfNPEAAAQBAJ?hl=en&gbpv=1&dq=google+cloud+certified+professional+network&printsec=frontcover

## DI-21: Log Sink Errors
These are specific to the Terraform Guardrails at this point - but we need to verify that they are OK in the Terraform LZ and the KCC LZ
```
---------- Forwarded message ---------
From: Google Cloud Logging <logging-noreply@google.com>
Date: Sat, Sep 17, 2022 at 4:28 PM
Subject: [ACTION REQUIRED] Cloud Logging sink configuration error in 93413315325
To: <admin-root@nuage-cloud.info>

OPEN CLOUD LOGGING

Cloud Logging
Error in Cloud Logging sink configuration

The following log sink in a organization you own had errors while routing logs. Due to this error, logs are not being routed to the sink destination.
Organization ID
93413315325
Log Sink Name
sk-c-logging-pub
Sink Destination
pubsub.googleapis.com/projects/guardrails-eaba/topics/tp-org-logs-5ufo
Error Code
topic_not_found
Error Detail
The specified Pub/Sub topic could not be found by the Cloud Logging service. Create the topic and grant publish permission for the service account specified in the sink's writerIdentity field on the topic. You can also set up Cloud Logging to use a different destination.
Fix this error by following steps documented in troubleshooting sinks. If the sink is no longer needed, it can be quickly removed using gcloud:
gcloud logging sinks delete sk-c-logging-pub --organization=93413315325
```
## DI-22: Audit Log Retention times - 1s and 365d
The current 1 is slated for non-modifiable audit logs - but we need to verify this and check the bucket lifecycle into long term storage

## DI-23: Verify the guardrails solution is embedded in the landing-zone solution

## DI-24: Validate vdom - virtual domain fortigate zone isolation
- Fortinet Fortigate config in https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/158
- The guidance on the KCC LZ project is that we use a single cluster (VDOM - multiple zone handling in one cluster) for both gc-cap and gc-tip and use flow separation or the existing LB sandwich architecture and 2 clusters of 2VMs for CAP/TIP separation.
- See TF PBMM LZ https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/45
- Verify the config and shadow deployment of a VDOM fortigate configaration - thanks Dave (triple fortigate)
- https://docs.fortinet.com/document/fortigate/6.0.0/cookbook/154890/vdom-configuration
- see https://cloud.google.com/architecture?category=networking&text=appliance to https://cloud.google.com/architecture/deploying-nat-gateways-in-a-hub-and-spoke-architecture-using-vpc-network-peering-and-routing?hl=en
## DI-25: Continuous Delivery Pipelines
- [Cloud Deploy](https://cloud.google.com/deploy) - GKE Pipelines - (242711314) - https://cloud.google.com/blog/products/devops-sre/google-cloud-deploy-now-ga
- Github actions
- Gitlab
- Jenkins

### Cloud Deploy Pipelines
Investigate use of [Cloud Deploy](https://cloud.google.com/deploy) as a pipeline layer in both the infrastructure and workload deployment automation.

<img width="1348" alt="Screen Shot 2022-09-30 at 9 19 38 AM" src="https://user-images.githubusercontent.com/94715080/193278579-5241ba61-114a-4fbc-b80b-9d2be37292af.png">

Follow quickstart on https://cloud.google.com/deploy/docs/deploy-app-run
- Can we use cloud deploy pipelines (krm compliant) as a layer between kpt and deployment rendering - to gain the additional capabliities of cloud deploy.
- start with a reference validation pipeline and move to workload via the folder
- https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/landing-zone/cicd-examples
- Issue ID pending

## DI-26: Guardrails Solution Sync up into Landing Zone Solution
- Chris noticed some discrepancies between the guadrails subset that are not in the landing zone
- I also noticed that we are missing the BigQuery log sink (in the TF GR solution) - see issue https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/154

## DI-27: Implement GateKeeper Security Center - SCC findings reporter
- This would be in addition to SCC Premium - findings tab - for NIST-800-53
- https://github.com/GoogleCloudPlatform/gatekeeper-securitycenter


## DI-28: Organization wide LZ affecting change management  
Request: "discuss folder structure and the promotion of changes to the landing zone. More specifically, as a landing zone admin, what is the recommended approach to implement a change that can potentially affect the whole organization,, including all environments.. ex. : org policies and gatekeeper policies."
### Tracking
### Discussion
- IE: sandbox project that requires the first use of a particular service, VPC peering, VPC connector... that causes a global org update
- Policy changes that affect all projects at the org or folder level

### Options
### Decision


## DI-29: Firewall Polices
- see https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/162
- VPC Firewall rules, Fortigate Policies, Cloud Armor Policies and Access Content Manager perimeters (part of beyond corp).
- firewall policies - https://cloud.google.com/vpc/docs/firewall-policies


## DI-30: ADFS vith AAD 
- https://cloud.google.com/community/tutorials/gcds-use-cases-common-and-complex
- SSO only
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/99

## DI-31: Enable VPC Flow Logs and Packet Mirroring Policies
- VPC flow logs are a sample of packets, for full packet analyis via for example IDS see https://cloud.google.com/vpc/docs/packet-mirroring?_ga=2.218767321.-175179844.1646174174

## DI-32: Determine notification for kpt render service modification failed on required service delete/create - IAM audit bucket member role 
- 49 Solutions specd.
- Get the criteria to determine when a lower impact modification apply (kubectl apply - under the covers) failed (where a full delete/create would have been required)

## DI-33: SCC - Enable Security Health Analytics and Web Security Scanner - for Vulnerabilities reporting
- Security Command Center's vulnerabilities dashboard to find potential weaknesses in your Google Cloud resources.  SCC  displays results only for projects in which Security Health Analytics and Web Security Scanner are enabled.
- Verify these are set - especially when we run the traffic generator for canary workload testing
- 

## DI-34: HA hot/warm/cold standby options for workloads
- Also verify HA version of the fortigate architecture being worked out in design meetings.  with/without LB sandwich.
- Cold standby can include full or partial deployment

# Installation/Deployment

### Deployment Preparations
#### Cloud Identity Onboarding and Organization Domain Validation
#### Billing Quota
#### Project Quota
#### Config Controller enabled GKE Cluster
- follow https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/solutions/landing-zone/README.md#usage


### Creating the Config Controller Cluster
Use the advanced install at https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/docs/advanced-install.md

Verify that the requireShieldedVM org policy is off for the folder or project before starting the CC cluster

```
michael@cloudshell:~ (landing-zone-controller-e4g7d)$ gcloud anthos config controller create landing-zone-controller --location northamerica-northeast1 --network kcc-controller --subnet kcc-regional-subnet
Create request issued for: [landing-zone-controller]
Waiting for operation [projects/landing-zone-controller-e4g7d/locations/northamerica-northeast1/operations/operation-1663186893923-5e8a8e001e619-34ef85f4-6e91f4fd] to complete...working.
```

### Updating the Config Controller Cluster
### Deleting the Config Controller Cluster
see https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/91

For the name, leave out the "krmapihost-" prefix
```
michael@cloudshell:~ (landing-zone-controller-1z583)$ gcloud anthos config controller delete landing-zone-controller --location=northamerica-northeast1
You are about to delete instance [landing-zone-controller]
Do you want to continue (Y/n)?  y
Delete request issued for: [landing-zone-controller]
Waiting for operation [projects/landing-zone-controller-1z583/locations/northamerica-northeast1/operations/operation-1663186645640-5e8a8d13563dd-418ffc6f-eb3f878d] to complete...working.
```
remember to delete the org policies added by the landing-zone to avoid https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/132
### Recreating the Config Controller Cluster
gcp.zone
```
michael@cloudshell:~ (landing-zone-controller-e4g7d)$ gcloud anthos config controller create landing-zone-controller --location northamerica-northeast1 --network kcc-controller --subnet kcc-regional-subnet
Create request issued for: [landing-zone-controller]
Waiting for operation [projects/landing-zone-controller-e4g7d/locations/northamerica-northeast1/operations/operation-1663188232198-5e8a92fc658f2-a614c3a2-993952f2] to complete...working..

3) Not all instances running in IGM after 26.129857499s. Expected 1, running 0, transitioning 1. Current errors: [CONDITION_NOT_MET]: Instance 'gke-krmapihost-landing-z-default-pool-eafd49e4-6msn' creation failed: Constraint constraints/compute.requireShieldedVm violated for project projects/landing-zone-controller-e4g7d. Secure Boot is not enabled in the 'shielded_instance_config' field. See https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints for more information.

```
Issue is that the requireShieldedVM org policy will not allow the CC GKE cluster to come back up - delete it first to avoid issues with the CC cluster in a now landing-zone controlled organization (which is normal behaviour from an lz view) - https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/132
last deployment was still OK
<img width="1483" alt="Screen Shot 2022-09-14 at 4 48 42 PM" src="https://user-images.githubusercontent.com/94715080/190259456-bb67b528-eae9-4092-ac38-77fdf4dc7ca5.png">

#### Recreating the Config Controller Cluster in another region
Switching to the northamerica-northeast2 region

Create a VPC and single subnet in the new region
```
michael@cloudshell:~/wse_github/GoogleCloudPlatform/landing-zone (landing-zone-controller-e4g7d)$ export CLUSTER=kcc2
michael@cloudshell:~/wse_github/GoogleCloudPlatform/landing-zone (landing-zone-controller-e4g7d)$ export NETWORK=kcc2
michael@cloudshell:~/wse_github/GoogleCloudPlatform/landing-zone (landing-zone-controller-e4g7d)$ export SUBNET=kcc2
michael@cloudshell:~/wse_github/GoogleCloudPlatform/landing-zone (landing-zone-controller-e4g7d)$ export REGION=northamerica-northeast2
michael@cloudshell:~/wse_github/GoogleCloudPlatform/landing-zone (landing-zone-controller-e4g7d)$ gcloud compute networks create $NETWORK --subnet-mode=custom
Created [https://www.googleapis.com/compute/v1/projects/landing-zone-controller-e4g7d/global/networks/kcc2].
NAME: kcc2
SUBNET_MODE: CUSTOM
BGP_ROUTING_MODE: REGIONAL
IPV4_RANGE:
GATEWAY_IPV4:

Instances on this network will not be reachable until firewall rules
are created. As an example, you can allow all internal traffic between
instances as well as SSH, RDP, and ICMP by running:

$ gcloud compute firewall-rules create <FIREWALL_NAME> --network kcc2 --allow tcp,udp,icmp --source-ranges <IP_RANGE>
$ gcloud compute firewall-rules create <FIREWALL_NAME> --network kcc2 --allow tcp:22,tcp:3389,icmp

michael@cloudshell:~/wse_github/GoogleCloudPlatform/landing-zone (landing-zone-controller-e4g7d)$ gcloud compute networks subnets create $SUBNET  \
--network $NETWORK \
--range 192.168.0.0/16 \
--region $REGION
Created [https://www.googleapis.com/compute/v1/projects/landing-zone-controller-e4g7d/regions/northamerica-northeast2/subnetworks/kcc2].
NAME: kcc2
REGION: northamerica-northeast2
NETWORK: kcc2
RANGE: 192.168.0.0/16
STACK_TYPE: IPV4_ONLY
IPV6_ACCESS_TYPE:
INTERNAL_IPV6_PREFIX:
EXTERNAL_IPV6_PREFIX:
michael@cloudshell:~/wse_github/GoogleCloudPlatform/landing-zone (landing-zone-controller-e4g7d)$

michael@cloudshell:~/wse_github/GoogleCloudPlatform/landing-zone (landing-zone-controller-e4g7d)$ gcloud anthos config controller create landing-zone-controller9 --location $REGION --network $NETWORK --subnet $SUBNET
Create request issued for: [landing-zone-controller9]
Waiting for operation [projects/landing-zone-controller-e4g7d/locations/northamerica-northeast2/operations/operation-1663775214611-5e931daa72dd2-0f4f4c7d-03c38fbd] to complete...w
orking   
```

### Deploying the Landing Zone
### Updating the Landing Zone from Upstream source
#### Reconciling
### Updating the Landing Zone Deployment with local changes
### Deleting the Landing Zone Deployment


# Deployments 

```mermaid
graph LR;
    style Landing-Zones fill:#44f,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
    %% mapped and documented

    on-prem-simulate-->prem
    identity-as-a-service-simulate-->idp-dev
    identity-as-a-service-simulate-->idp-uat
    3rd-cloud-->dev-aws
    
    manual-->sbx
    manual-->dev
    automated-->uat
    automated-->prd
    
    prem-->onprem.gcp.zone
    idp-dev-->azure.obrienlabs.dev
    idp-uat-->azure.cloudnuage.dev
    dev-->approach.gcp.zone-->procedure/verify
    dev-aws-->aws.cloudnuage.dev
    sbx-->checklist.gcp.zone-->experiment
    prd-->landing.gcp.zone-->resilient/stable
    uat-->alternate.gcp.zone-->cicd/automated
    sbx-->gcp.zone-->experiment
    sbx-->arg.corporate-->experiment
    gcp.zone-->gcp-domain-zone
        
```

# References
- Anthos Config Management - "Deploy a Landing Zone Blueprint" - https://cloud.google.com/anthos-config-management/docs/tutorials/landing-zone and 
- Config Connector release notes - https://cloud.google.com/config-connector/docs/release-notes
- [nomos](https://cloud.google.com/anthos-config-management/docs/how-to/nomos-command) CLI for anthos config controller  (init vet status hydrate)
- KPT functions catalog - https://github.com/GoogleContainerTools/kpt-functions-catalog
- Starlark runtime (for yaml scripting - kpt/k8s) https://googlecontainertools.github.io/kpt/guides/producer/functions/starlark/


# TODO - to integrate into this doc and the issue system
20220913
- Detail branching/PR/release/tagging strategy doc/procedures
- Detail CD clean deployment on remote org as PR on demand (+1) regression testing (full LZ install with infrastructure - not just actual LZ solution)
- Provide doc/tooling to add secure zone deployment bastion VM in addition to default cloud shell and local developer SDK
- Detail admin super-admin role of org admin not required for LZ deploy - role add/delete are automated
- Dev workflow assistance: Fully delete/recreate LZ (reuse procedure for CD redeploys) - up to fully clean organization
- Prepare workaround for 25 limit on VPC Peering connections - after forest of division/team/workload projects passes 25
- - 
- Detail Canary CD and ATO traffic generation app with UAT/Firewall config to both exercise the LZ and demo serverless/IaaS/PaaS workload example
- Unclassified/Classified separation of Profile 3/5/6 workloads via VPC separation
- SC2G GC-TIP Dev test version of IPSEC VPN (leave out interconnect for cost) - for cloud to ground workload testing (IE: DB on prem, app on CSP)
- SC2G prepare DNS flows in prep for 30d prior WIF (workload intake form) per workload - have example shared PaaS and custom IaaS/SaaS flows
- CCCS project and zoning for logging agent placement and traffic flows
- Expand zoning on existing shared workload PaaS ready Shared VPC host/service projects with 1:1 service project subnets
- Detail zoning for per-team workload separate VPC with its own perimeter peering and VPC endpoints
- Onboarding: Dev only: Full/Paid Accounts: detail procedure on adding day 1 Full/Paid accounts before LZ deployment - 90d free stays (all others use shared billing)
- Onboarding: Quota: Do GCP projects/billing association quota increase from 5 to 20 before LZ deployment
- Onboarding: Quota: expand projects limit from 20 to 50 in prep for running out of project quota on dev recycling of parameterized project IDs
- RFC-6598 perimeter VPC
- RFC-1918 dev/staging
- SC2G GC-CAP ingress/egress traffic must be decrypted (except finance/health by ip rule exclusion)
- GoC root cert on all endpoints - https://www.gcpedia.gc.ca/wiki/Non-Person_Entity_Public_Key_Infrastructure#Root_Certificate_Authorities
- detail option to create cluster during root readme or as part of the lz solution
- Dev workaround for timed out cluster creation (we are usually 5 min from a 30 min timeout on 25 min duration)

Notes
- CE = customer edge
- high level diagram at cxp with active/passive router deployments
- pre-shared key (psk)
- internal /30 bgp peering through tunnel
- ipsec phase 1/2 params
- fortinet vip
- ipsec + bgp configs
- bgp through tunnel peering / route table
- tunnel failover and app testing

- SC2G
- MacSEC protocol through CE routers - for pbmm flows encrypted across gcbb
- MacSEC tunnels ground ce to tip ce (mon/tor)
- cxp = cloud exchange provider (2 parts vpn(iis/eps, gc-cap
- eps = enterprise perimeter security system
- pbmm traffix must traverse macsec and ipsec tunnels
- non-pbmm traffic via l3 gcbb mpls service
- casb (cloud access security broker) for saas (2023)
- iaas perimeter firewall, tls, ips, sandboxing, l3 l7 inbound controls, logging
- cse/cccs via sc2g

- flows from cloud tenancy to cap: 100.96 rfc6598 (snat address)

- no snat for tip
- cloud interconnect bandwidth shared between cap/tip
- manditory rfc6598 (perimeter vpc) and 1918 (dev/stg/prod zones)
- 100.96 for ext facing fw - distinct between csps
- no cloud/ground ip address overlaps

- paz:
- public zone zip
- ean
- ean/dmz boundary
- dmz
- ian
- internal zone zip
- all flows documented in wif
- uat for cloud tenancy
- edc rz
- cap traversal latency 20-30 ms
- 2 CxP at each region
- approved fw for sc2g not including waf


## Review
- contitional IAM https://cloud.google.com/iam/docs/conditions-overview
- Anthos Config Management https://cloud.google.com/anthos/config-management
- Binauthz - attestation (on binary authorization) - for cloud deploy policy engine https://cloud.google.com/binary-authorization/docs/making-attestations
- https://cloud.google.com/vpc/docs/packet-mirroring?_ga=2.218767321.-175179844.1646174174
- Firewall policies - https://cloud.google.com/vpc/docs/firewall-policies
- PII DLP - https://cloud.google.com/architecture/de-identification-re-identification-pii-using-cloud-dlp
- VPC Service Perimeter for data exfiltration - https://cloud.google.com/vpc-service-controls/docs/service-perimeters - part of BeyondCorp ACM Access Context Manager
- https://cloud.google.com/architecture/pci-dss-and-gke-guide
- Bucket retention and locks - https://cloud.google.com/storage/docs/bucket-lock
- Transit Gateway like https://cloud.google.com/network-connectivity-center
- Forseti - Security inventory, monitoring, enforcement - https://forsetisecurity.org/



- SCC enablement even for standard is required
- https://console.cloud.google.com/security/command-center/config/access;setup=true?organizationId=925207728429&orgonly=true&supportedpurview=organizationId
```
gcloud organizations add-iam-policy-binding 925207728429\
    --member serviceAccount:service-org-925207728429@security-center-api.iam.gserviceaccount.com\
    --role roles/securitycenter.serviceAgent &&\
gcloud organizations add-iam-policy-binding 925207728429\
    --member serviceAccount:service-org-925207728429@security-center-api.iam.gserviceaccount.com\
    --role roles/serviceusage.serviceUsageAdmin &&\
gcloud organizations add-iam-policy-binding 925207728429\
    --member serviceAccount:service-org-925207728429@security-center-api.iam.gserviceaccount.com\
    --role roles/cloudfunctions.serviceAgent
```
