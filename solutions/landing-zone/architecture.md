# PBMM KCC Landing Zone Architecture


## Purpose
Create, manage and operate a PBMM secure landing zone for the Google Cloud Environment. 
This project details the architecture for a mult-tenant Landing Zone as a Service - where multiple deptartments and workloads deploy under a shared organization with TBD folder separation.

### Background

The Google Cloud PBMM Secure [Landing Zone](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/landing-zone) is a GCP services based - modular and scalable Infrastructure as Code configuration that enables an organization to deploy their business workflow and processes.  The landing zone is the prerequisite to deploying enterprise workloads in a cloud environment either all cloud native or a hybrid combination of on-prem.  The landing zone provides for GitOps automated deployment and management by the overall DevSecOps teams.  Workload migration and integration with a federated IdP is part of the extended API offered by the Google Cloud Landing Zone.  The system is focused on providing a secure zoned network infrastructure around various types of department workloads. 

### Scope
The scope of this assessment is limited to the Infrastructure as Service oriented GCP services that provide for a minimal secure landing zone.  Security assessments specific to IaaS/PaaS/SaaS/Hybrid workloads are part of a later stage.  The security profile for the GCP PBMM Landing Zone is PB (Protected B) confidentiality, Medium integrity, Medium availability (PBMM).


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

#### High Level PaaS Workflow Example
see https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/architecture.md#system-architecture-high-level-workload-overview
![img](img/_gcp_pbmm_lz_sa_paas_workload_overview.png)


#### High Level Network Diagram
- Common Services Project - and "Shared Services", "SharedInfrastructure" - in the high level network diagram - https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/dev/solutions/landing-zone/architecture.md#high-level-network-diagram - the common services project contains services like SSO, backup, IAP and any CI/CD infrastructure that would be common to a cross section of the workloads projects.  I will adjust the diagram to rename it "shared services".  A subset may reside in "SharedInfrastructure" depending on how we partition between a service and deployment infrastructure
![img](img/_landingzone-high-level-op-concept.png)

![img](img/_landingzone_system_interface_description.png)

#### Low Level Zoning Diagram
- _landingzone_system_comm_description
- <img width="1668" alt="_20221024_lz_low_level_arch" src="https://user-images.githubusercontent.com/94715080/197665816-60b93de2-198b-47fd-9d25-ccdb3dd4b678.png">

#### Organization/Folder/Projects Example
![img](img/_gcp_org_folders_projects.png)

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

 - Accessing Security Command Center via API - https://cloud.google.com/security-command-center/docs/how-to-programmatic-access#python
 - Accessing SCC via gcloud https://cloud.google.com/sdk/gcloud/reference/scc
 - 
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
- 20221018:  [fortigate-tutorial-gcp](https://github.com/fortinet/fortigate-tutorial-gcp) - thanks Dave
- Need to spin up/verify an alternative to regular peering (due to the 25 limit/project) for the hub-spoke pattern
https://cloud.google.com/network-connectivity/docs/network-connectivity-center/concepts/overview over the normal https://cloud.google.com/architecture/deploy-hub-spoke-vpc-network-topology 

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
The specified Pub/Sub topic could not be found by the Cloud Logging service. Create the topic and grant publish permission for the service account specified in the sink's writer. Identity field on the topic. You can also set up Cloud Logging to use a different destination.
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
### Fortigate Multitenant Architecture
- see https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/158#issuecomment-1332214668
- The current architecture design - see the slide share at https://docs.google.com/presentation/d/19B3gdZ1ukrRekEFQ1UIWsZJJi4ElABzziKEkPnS54uI/edit#slide=id.gff25b70edb_0_0 is at least one fortigate HA cluster per organization with unclass and classified zones sharing one Fortigate HA cluster for now.  There may be an option to split traffic across 2 clusters per GC-CAP and GC-TIP but for now we are going with a single cluster per organization.
- There may be a use case for a shared Fortigate HA cluster under the Landing Zone as a Service model - but this LZaaS model is handled currently using Shared VPC's
- Performance implications of the Fortigate cluster need to be determined.  The current standard is for at least 1 vCPU per NIC - where our default Fortigate VM has 4 NICs.  For maximum throughput we recommend 2 to 4 times vCPU's per NIC with the associated RAM and 10+Gbps network throughput
- For example the recommended N2-standard-4 VM type has 4vCPUs, 16GB ram and under 10Gbps
- <img width="568" alt="Screen Shot 2022-11-28 at 3 14 35 PM" src="https://user-images.githubusercontent.com/94715080/204372097-f9f9a5c8-6aef-4f3e-83fd-6414765e10fb.png">
- However the n2-standard-16 at 32 vCPU and 128GB ram can be provisioned (when using a gVNIC) past 32Gbps to 50Gbps
- <img width="561" alt="Screen Shot 2022-11-28 at 3 18 17 PM" src="https://user-images.githubusercontent.com/94715080/204372702-2384b18d-1b23-400c-a30a-70cc2d29f70d.png">
- <img width="567" alt="Screen Shot 2022-11-28 at 3 18 47 PM" src="https://user-images.githubusercontent.com/94715080/204372774-6007f1e6-8c35-44a9-a5e9-c5baa7058dfe.png">
- Other criteria for NGFW HA cluster mapping is around the 25 limit on peering https://cloud.google.com/architecture/architecture-centralized-network-appliances-on-google-cloud#choosing_an_option_for_attaching_network_segments . The backup to the limitation via VPN will also reduce the egress bandwidth as a fallback option.
- There is also the NGFW policy question / org
- We will need to monitor the egress traffic in this distributed/org setup to see if the cost/org is justified


### Fortigate HA Active Standby POC
- tracking MGMT NIC and NAT specific https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/166
- tracking deploying example https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/158
- tracking add kcc version of fortigate-tutorial-gcp (collaboration PR) https://github.com/fortinet/fortigate-tutorial-gcp/issues/5
- Using the reference architecture (thanks Dave) - from Fortinet around dual fortigate VMs with 4 nics each in 4 perimeter VPCs and 2 example workload VPCs.
- see https://github.com/fortinet/fortigate-tutorial-gcp/issues/1 for details on deployment
- Note you will need to ask for a compute.networks quota increase from 5 to 10 (you can also delete the default VPC)
- <img width="402" alt="Screen Shot 2022-10-20 at 10 33 22 AM" src="https://user-images.githubusercontent.com/94715080/196978094-1c3a6b13-ea9d-4d88-a708-501fe6305512.png">
- <img width="1640" alt="Screen Shot 2022-10-20 at 10 34 08 AM" src="https://user-images.githubusercontent.com/94715080/196978326-0d5ae2da-57e0-4d88-b592-7aef14308784.png">
- After the quota increase - we have 6 VPCs



<img width="1664" alt="Screen Shot 2022-10-24 at 10 57 27 PM" src="https://user-images.githubusercontent.com/94715080/197672665-ae86c174-1fbb-4e19-96d3-36c8db54d21b.png">

<img width="1829" alt="Screen Shot 2022-10-24 at 10 58 13 PM" src="https://user-images.githubusercontent.com/94715080/197672666-eb66ef04-a04d-4149-b417-09db0b0e923a.png">

<img width="1448" alt="Screen Shot 2022-10-24 at 10 58 34 PM" src="https://user-images.githubusercontent.com/94715080/197672670-9c8a013f-3c2c-429a-b669-f2fe5d5cbd69.png">

<img width="1853" alt="Screen Shot 2022-10-24 at 10 59 00 PM" src="https://user-images.githubusercontent.com/94715080/197672675-1d087cf1-f90e-4af8-a926-bd34c7b0ec43.png">

<img width="2112" alt="Screen Shot 2022-10-24 at 10 59 24 PM" src="https://user-images.githubusercontent.com/94715080/197672677-9705bea9-0645-43c4-93df-e6c602891863.png">

<img width="1624" alt="Screen Shot 2022-10-24 at 10 59 40 PM" src="https://user-images.githubusercontent.com/94715080/197672681-36b111b4-6ed1-4091-adb6-7efa63d08c5d.png">

<img width="1541" alt="Screen Shot 2022-10-24 at 10 59 52 PM" src="https://user-images.githubusercontent.com/94715080/197672682-0f365964-b01f-474a-b1e0-fc070db5bd43.png">

<img width="1759" alt="Screen Shot 2022-10-24 at 11 00 17 PM" src="https://user-images.githubusercontent.com/94715080/197672684-5a257460-e443-4797-aba9-f2b76297639f.png">

<img width="1591" alt="Screen Shot 2022-10-24 at 11 00 29 PM" src="https://user-images.githubusercontent.com/94715080/197672686-d1133b3e-b8ec-4721-b500-0b82de386b71.png">

<img width="1673" alt="Screen Shot 2022-10-24 at 11 01 19 PM" src="https://user-images.githubusercontent.com/94715080/197672690-7e3bec11-f927-466d-b088-b105694180e1.png">

<img width="1671" alt="Screen Shot 2022-10-24 at 11 01 42 PM" src="https://user-images.githubusercontent.com/94715080/197672691-94dddbae-60a0-4de4-add1-5b1798c1cba4.png">

<img width="1671" alt="Screen Shot 2022-10-24 at 11 01 56 PM" src="https://user-images.githubusercontent.com/94715080/197672692-fe289026-ffae-402c-a36f-397652c6243f.png">





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

## DI-35: Multi Organization Control
fyi, Multi-org setup - Sean (49 Solutions) and I were creating new orgs and he mentioned he hadsee all orgs under one account and how to do it.  Quick google check verified that it is the same as sharing billing - just share iam roles (org admin+) on either side.
Does answer a couple questions we had about the multi-org part of multi-tenancy (we are currently using folders)

https://cloud.google.com/resource-manager/docs/managing-multiple-orgs

<img width="1066" alt="Screen Shot 2022-10-25 at 5 40 44 PM" src="https://user-images.githubusercontent.com/94715080/197887396-4d0160bc-362d-42f3-b09c-e6a84f550e8a.png">


## DI-36: Incorporate Software Delivery Shield
### Software Delivery Shield
- Next 22 https://cloud.google.com/blog/products/devops-sre/introducing-software-delivery-shield-from-google-cloud
- Cloud Workstations https://cloud.google.com/workstations
- Source Protect (part of Cloud Code) - https://cloud.google.com/code
- Binary Authorization - https://cloud.google.com/binary-authorization
- Assured Open Source Software - https://cloud.google.com/assured-open-source-software
- SLSA Level 3 in [Cloud Build](https://cloud.google.com/build) and [Cloud Deploy](https://cloud.google.com/deploy) - https://slsa.dev/ 
- Security Posture Management capabilities for [GKE](https://cloud.google.com/kubernetes-engine) (can be used in a SIEM - security information and event management system via [Pub/Sub](https://cloud.google.com/pubsub) or [Pub/Sub Lite](https://cloud.google.com/pubsub/lite/docs) - https://cloud.google.com/kubernetes-engine/docs/concepts/about-security-posture-dashboard

## DI-37: Config Controller vs Config Connector - Managed vs CRDs
- https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/180

## DI-38: Identity Federation
https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/182

see https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/architecture.md#di-4-cloud-identity-federation

See Identity Onboarding and Federation options at https://cloud.google.com/architecture/landing-zones/decide-how-to-onboard-identities
- using Option 2  
- using https://cloud.google.com/architecture/identity/federating-gcp-with-azure-active-directory
- https://cloud.google.com/architecture/identity/reference-architectures#using_an_external_idp

#### SSO only
- Verify details of backing IAM Identity user/role as part SSO federated IdP user auth during IAP session https://cloud.google.com/iap/docs/concepts-overview 
- Verify GCP Identity role for application use is available via the IAP session token - thinking https://cloud.google.com/iap/docs/signed-headers-howto#controlling_access_with_sign_in_attributes 
- see https://cloud.google.com/architecture/identity/single-sign-on
"To use SSO, a user must have a user account in Cloud Identity or Google Workspace and a corresponding identity in the external IdP"


## DI-39: Enable Security Command Center reporting of GKE KCC and Workload Clusters
https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/pull/183

# Installation/Deployment

### Deployment Preparations
#### Cloud Identity Onboarding and Organization Domain Validation
#### Billing Quota
#### Project Quota
#### Config Controller enabled GKE Cluster
- follow https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/solutions/landing-zone/README.md#usage



### Creating the Config Controller Cluster
- see https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/33
- Use the advanced install at https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/docs/advanced-install.md

Verify that the requireShieldedVM org policy is off for the folder or project before starting the CC cluster

```

Watch for multiple billing accounts - pick the right one - as the script takes the first in sequence

export CC_PROJECT_ID=controller-agz-1201
export REGION=northamerica-northeast1
export NETWORK=pdt-vpc
export SUBNET=pdt
export BOOT_PROJECT_ID=$(gcloud config list --format 'value(core.project)')
echo $BOOT_PROJECT_ID
pubsec-declarative-agz
export ORG_ID=$(gcloud projects get-ancestors $BOOT_PROJECT_ID --format='get(id)' | tail -1)
echo $ORG_ID
6839210352
export BILLING_ID=$(gcloud alpha billing projects describe $BOOT_PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
echo $BILLING_ID
019283-6F1AB5-7AD576

root_@cloudshell:~/wse_github/obriensystems/pubsec-declarative-toolkit (pubsec-declarative-agz)$ gcloud projects create $CC_PROJECT_ID --name="Config Controller" --labels=type=infrastructure-automation --set-as-default
Create in progress for [https://cloudresourcemanager.googleapis.com/v1/projects/controller-agz-1201].
Waiting for [operations/cp.7683542102938739329] to finish...done.    
Enabling service [cloudapis.googleapis.com] on project [controller-agz-1201]...
Operation "operations/acat.p2-482702030934-67906db4-95f9-4ed3-b34d-8061b192168e" finished successfully.
Updated property [core/project] to [controller-agz-1201].
root_@cloudshell:~/wse_github/obriensystems/pubsec-declarative-toolkit (controller-agz-1201)$ gcloud beta billing projects link $CC_PROJECT_ID --billing-account $BILLING_ID
billingAccountName: billingAccounts/019283-6F1AB5-7AD576
billingEnabled: true
name: projects/controller-agz-1201/billingInfo
projectId: controller-agz-1201
root_@cloudshell:~/wse_github/obriensystems/pubsec-declarative-toolkit (controller-agz-1201)$ gcloud config set project $CC_PROJECT_ID
Updated property [core/project].

root_@cloudshell:~/wse_github/obriensystems/pubsec-declarative-toolkit (controller-agz-1201)$ gcloud services enable krmapihosting.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com accesscontextmanager.googleapis.com
Operation "operations/acf.p2-482702030934-71d1d53e-7745-4133-9c10-7da1ce2f2099" finished successfully.

root_@cloudshell:~/wse_github/obriensystems/pubsec-declarative-toolkit (controller-agz-1201)$ gcloud compute networks create $NETWORK --subnet-mode=custom
Created [https://www.googleapis.com/compute/v1/projects/controller-agz-1201/global/networks/pdt-vpc].
NAME: pdt-vpc
SUBNET_MODE: CUSTOM
BGP_ROUTING_MODE: REGIONAL
IPV4_RANGE:
GATEWAY_IPV4:

Instances on this network will not be reachable until firewall rules
are created. As an example, you can allow all internal traffic between
instances as well as SSH, RDP, and ICMP by running:

$ gcloud compute firewall-rules create <FIREWALL_NAME> --network pdt-vpc --allow tcp,udp,icmp --source-ranges <IP_RANGE>
$ gcloud compute firewall-rules create <FIREWALL_NAME> --network pdt-vpc --allow tcp:22,tcp:3389,icmp

root_@cloudshell:~/wse_github/obriensystems/pubsec-declarative-toolkit (controller-agz-1201)$ gcloud compute networks subnets create $SUBNET --network $NETWORK --range 192.168.0.0/16 --region $REGION

```

<img width="1502" alt="Screen Shot 2022-12-01 at 12 20 43 PM" src="https://user-images.githubusercontent.com/94715080/205118472-4e02806b-b2d7-4f72-a7fe-e77ead987a29.png">

Create the GKE cluster - usually 5 but could take up to 30 min
```



1230
gcloud anthos config controller create landing-zone-controller --location northamerica-northeast1 --network kcc-controller --subnet kcc-regional-subnet
Create request issued for: [landing-zone-controller]
Waiting for operation [projects/landing-zone-controller-e4g7d/locations/northamerica-northeast1/operations/operation-1663186893923-5e8a8e001e619-34ef85f4-6e91f4fd] to complete...working.
```
<img width="1557" alt="Screen Shot 2022-12-01 at 12 39 53 PM" src="https://user-images.githubusercontent.com/94715080/205122468-2b4cf94d-780d-4322-9682-f5bf1fe9e2c3.png">

Timeout after 40 min - switching to us-west1 and anthos option --full-management

```
root_@cloudshell:~/wse_github/obriensystems/pubsec-declarative-toolkit (controller-agz-1201)$ export CLUSTER=pdt-w1
root_@cloudshell:~/wse_github/obriensystems/pubsec-declarative-toolkit (controller-agz-1201)$ export NETWORK=pdt-w1-vpc
root_@cloudshell:~/wse_github/obriensystems/pubsec-declarative-toolkit (controller-agz-1201)$ gcloud compute networks create $NETWORK --subnet-mode=custom
Created [https://www.googleapis.com/compute/v1/projects/controller-agz-1201/global/networks/pdt-w1-vpc].
NAME: pdt-w1-vpc
SUBNET_MODE: CUSTOM
BGP_ROUTING_MODE: REGIONAL
IPV4_RANGE:
GATEWAY_IPV4:
root_@cloudshell:~/wse_github/obriensystems/pubsec-declarative-toolkit (controller-agz-1201)$ gcloud compute networks subnets create $SUBNET --network $NETWORK --range 192.168.0.0/16 --region $REGION
Created [https://www.googleapis.com/compute/v1/projects/controller-agz-1201/regions/us-west1/subnetworks/pdt].
NAME: pdt
REGION: us-west1
NETWORK: pdt-w1-vpc
RANGE: 192.168.0.0/16
STACK_TYPE: IPV4_ONLY
IPV6_ACCESS_TYPE:
INTERNAL_IPV6_PREFIX:
EXTERNAL_IPV6_PREFIX:

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

Get a connection to the GKE Kubernetes cluster running KCC.


```
gcp.zone
michael@cloudshell:~ (landing-zone-controller-e4g7d)$ gcloud container clusters get-credentials krmapihost-landing-zone-controller9 --region northamerica-northeast2
Fetching cluster endpoint and auth data.
kubeconfig entry generated for krmapihost-landing-zone-controller9.

michael@cloudshell:~ (landing-zone-controller-e4g7d)$ kubectl get nodes
NAME                                                  STATUS   ROLES    AGE   VERSION
gke-krmapihost-landi-krmapihost-landi-1ad6d226-0t58   Ready    <none>   10d   v1.23.8-gke.1900
gke-krmapihost-landi-krmapihost-landi-3c83b5c4-7n9m   Ready    <none>   10d   v1.23.8-gke.1900
gke-krmapihost-landi-krmapihost-landi-e79f699c-gsc2   Ready    <none>   10d   v1.23.8-gke.1900

michael@cloudshell:~ (pubsec-declarative-tk-gz)$ kubectl get pods -n cnrm-system
NAME                                             READY   STATUS    RESTARTS   AGE
cnrm-controller-manager-ccljafcgkgtfkvoj8280-0   2/2     Running   0          10d
cnrm-deletiondefender-0                          1/1     Running   0          10d
cnrm-resource-stats-recorder-5d6bd8cc5b-k9ccj    2/2     Running   0          10d
cnrm-unmanaged-detector-0                        1/1     Running   0          10d
cnrm-webhook-manager-545b8bbf4b-2ghbd            1/1     Running   0          10d
cnrm-webhook-manager-545b8bbf4b-bxm8z            1/1     Running   0          10d

michael@cloudshell:~ (pubsec-declarative-tk-gz)$ kubectl logs -n cnrm-system cnrm-controller-manager-ccljafcgkgtfkvoj8280-0 --follow

{"severity":"info","timestamp":"2022-11-11T22:49:49.515Z","logger":"controller.computeroute-controller","msg":"Starting workers","reconciler group":"compute.cnrm.cloud.google.com","reconciler kind":"ComputeRoute","worker count":20}
{"severity":"info","timestamp":"2022-11-11T22:49:49.516Z","logger":"controller.memcacheinstance-controller","msg":"Starting workers","reconciler group":"memcache.cnrm.cloud.google.com","reconciler kind":"MemcacheInstance","worker count":20}

michael@cloudshell:~/wse_github/GoogleCloudPlatform (pubsec-declarative-tk-gz)$ cd landing-zone/
michael@cloudshell:~/wse_github/GoogleCloudPlatform/landing-zone (pubsec-declarative-tk-gz)$ kpt fn render
Package "landing-zone/environments/common/guardrails-policies":
Package "landing-zone/environments/common":
[RUNNING] "gcr.io/kpt-fn/set-namespace:v0.4.1"
[PASS] "gcr.io/kpt-fn/set-namespace:v0.4.1" in 1.8s
  Results:
    [info]: all namespaces are already "config-control". no value changed

Package "landing-zone/environments/nonprod":
[RUNNING] "gcr.io/kpt-fn/set-namespace:v0.4.1"
[PASS] "gcr.io/kpt-fn/set-namespace:v0.4.1" in 200ms
  Results:
    [info]: all namespaces are already "config-control". no value changed

Package "landing-zone/environments/prod":
[RUNNING] "gcr.io/kpt-fn/enable-gcp-services:v0.1.0"
[PASS] "gcr.io/kpt-fn/enable-gcp-services:v0.1.0" in 2.5s
  Results:
    [info] serviceusage.cnrm.cloud.google.com/v1beta1/Service/config-control/prod-nethost-service-compute: recreated service
    [info] serviceusage.cnrm.cloud.google.com/v1beta1/Service/config-control/prod-nethost-service-logging: recreated service
[RUNNING] "gcr.io/kpt-fn/set-namespace:v0.4.1"
[PASS] "gcr.io/kpt-fn/set-namespace:v0.4.1" in 200ms
  Results:
    [info]: all namespaces are already "config-control". no value changed

Package "landing-zone":
[RUNNING] "gcr.io/kpt-fn/apply-setters:v0.2"
[PASS] "gcr.io/kpt-fn/apply-setters:v0.2" in 1.5s
  Results:
    [info] metadata.annotations.cnrm.cloud.google.com/organization-id: set field value to "925207728429"
    [info] metadata.annotations.cnrm.cloud.google.com/organization-id: set field value to "925207728429"
    [info] spec.projectID: set field value to "net-perimeter-prj-common-gz1"
    [info] spec.parentRef.external: set field value to "925207728429"
    ...(87 line(s) truncated, use '--truncate-output=false' to disable)
[RUNNING] "gcr.io/kpt-fn/generate-folders:v0.1.1"
[PASS] "gcr.io/kpt-fn/generate-folders:v0.1.1" in 3.3s
[RUNNING] "gcr.io/kpt-fn/enable-gcp-services:v0.1.0"
[PASS] "gcr.io/kpt-fn/enable-gcp-services:v0.1.0" in 1.3s
  Results:
    [info] serviceusage.cnrm.cloud.google.com/v1beta1/Service/config-control/nonprod-nethost-service-compute: recreated service
    [info] serviceusage.cnrm.cloud.google.com/v1beta1/Service/config-control/nonprod-nethost-service-dns: recreated service
    [info] serviceusage.cnrm.cloud.google.com/v1beta1/Service/config-control/nonprod-nethost-service-logging: recreated service
    [info] serviceusage.cnrm.cloud.google.com/v1beta1/Service/config-control/prod-nethost-service-compute: recreated service
    ...(3 line(s) truncated, use '--truncate-output=false' to disable)
[RUNNING] "gcr.io/kpt-fn/gatekeeper:v0.2.1"
[PASS] "gcr.io/kpt-fn/gatekeeper:v0.2.1" in 2.4s
[RUNNING] "gcr.io/kpt-fn/kubeval:v0.3.0"
[PASS] "gcr.io/kpt-fn/kubeval:v0.3.0" in 17.5s

Successfully executed 9 function(s) in 5 package(s).


michael@cloudshell:~/wse_github/GoogleCloudPlatform/landing-zone (pubsec-declarative-tk-gz)$ kpt live apply --reconcile-timeout=2m --output=table
default     ConfigMap/setters                         Successful    Current                 <None>                                    15s     Resource is always ready
default     StorageBucket/audit-audit-prj-id-gz1      Successful    InProgress              Ready                                     14s     No controller is managing this resource.
```

### Deleting the Landing Zone Deployment

# FinOps
## KCC Cluster
- $14 CAD/day for GKE standard 3 node default zonal
- $4 CAD/day for GKE standard default


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
- Anthos Config Management – Policy Controller Library - CIS Foundation Benchmark checks in SCC-Premium and https://github.com/GoogleCloudPlatform/acm-policy-controller-library
- [nomos](https://cloud.google.com/anthos-config-management/docs/how-to/nomos-command) CLI for anthos config controller  (init vet status hydrate)
- KPT functions catalog - https://github.com/GoogleContainerTools/kpt-functions-catalog
- Starlark runtime (for yaml scripting - kpt/k8s) https://googlecontainertools.github.io/kpt/guides/producer/functions/starlark/
- GoC Cloud Brokerage https://gc-cloud-services.canada.ca/s/cloud-fa-catalog?language=en_US&id=0010A000005vhilQAA
- https://seroter.com/2021/08/18/using-the-new-google-cloud-config-controller-to-provision-and-manage-cloud-services-via-the-kubernetes-resource-model/


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
- Tags on Storage Buckets - https://cloud.google.com/storage/docs/tags-and-labels#examples_for_attaching_tags_to_buckets
- Private Service Connect and VPC Service Controls https://cloud.google.com/vpc/docs/configure-private-service-connect-services-controls


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
