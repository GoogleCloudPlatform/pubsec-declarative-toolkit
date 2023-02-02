# Security Controls Mappings



WARNING - use the following up to date security controls document in the PBMM repo

See corresponding Terraform based PBMM security controls Mappings - https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-security-controls.md


# deprecated
The purpose of this document is to detail the relationship/coverage/evidence between ITSG-33 security controls and corresponding GCP services.

[ITSG-33 Security Controls Grid](#security-controls) | [Google Cloud Platform Services - Mapped to Controls](#google-cloud-services)

## Controls Coverage
Use the new "All Products" page for a list of Google Cloud Services https://console.cloud.google.com/products

```mermaid
graph LR;
    style GCP fill:#44f,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
    %% mapped and documented
    
    
    %% mapped but not yet documented
    KCC-->AC-4;
    KCC-->AC-17.1;
    KCC-->AC-20.3;
    KCC-->AU-8;
    KCC-->AU-9;
    KCC-->CA-3;
    KCC-->IA-2.1;
    KCC-->IA-2.2;
    KCC-->RA-5;
    KCC-->SC-7;
    KCC-->SC-7.3;    
    KCC-->SC-7.5;
    KCC-->SA-4;
    KCC-->SI-3;
    KCC-->SI-4;
    

    KCC-->AC-2/2.1/3/5/6/6.5/6.10/7/12/19;
    KCC-->AT-3;
    KCC-->AU-2/3/3.2/4/6/9.4;
    KCC-->CM-2/3/4/5/8;
    KCC-->CP-7;
    KCC-->IA-2/4/5/5.1/5.7/5.13/6/8;
    KCC-->IR-6;
    KCC-->SA-22;
    KCC-->SC-5/7.7/8/8.1/12/13/17/28/28.1;
    KCC-->SI-2;
    
    %% control to sub-service
    AC-4-->IDS;
    AC-4-->VFW;
    AC-17.1-->IAP;
    AC-20.3-->BeyondCorp-CAA;
    AU-8-->Event-Logging;
    
    %% post-KCC
    
    %% requires Traffic Generation app
    AU-12== traffic gen ==>VPC-Flow-Logs;
    AU-12== traffic gen ==>SCC-Findings;
    AU-12-->SCC-Compliance;
    
    
    SC-7-->Location-Restriction
    AU-9-->Non-Public-->Cloud-Storage;
    AU-9-->Protection-Retention-->Cloud-Storage;
    CA-3-->IAP;
    CA-3-->Deployment-Manager;
    CA-3-->Private-Access;
    IA-2.1-->Identity-Federation;
    IA-2.2-->Identity-Federation;
    IA-2.1-->IAP;
    IA-2.1-->Roles;
    IA-2.2-->Roles;
    
    RA-5-->SCC-Vulnerabilities;
    RA-5-->Vulnerability-Scanning;
    SA-4-->SCC-Vulnerabilities;
    SA-4-->Vulnerability-Scanning;
    SC-7-->Resource-Location-Restriction;
    SC-7== traffic gen ==>VPC-Firewall-Logs;
    SC-7.3== traffic gen ==>VPC-Firewall-Logs;
    SC-7.5== traffic gen ==>VPC-Firewall-Logs;
    SC-8-->Encryption-at-rest;
    SC-8-->Encryption-in-transit;
    SC-28.1-->Encryption-at-rest;
    SC-28-->Encryption-at-rest;
    SI-3-->Vulnerability-Scanning;
    SI-3-->SCC-Vulnerabilities;
    SI-4== traffic gen ==>Compute-VM;
    
    %% sub-service to service
    BeyondCorp-CAA-->Security;
    Cloud-Identity-->Google-Admin;
    Compute-VM-->Cloud-Logging;
    Encryption-in-transit-->Security;
    Encryption-at-rest-->Security;
    Event-Logging-->Cloud-Operations-Suite;
    IAP-->Security;
    Identity-Federation-->IAM;
    IDS-->Network-Security;
    Location-Restriction-->IAM;
    MFA---->Cloud-Identity;
    Private-Access-->VPC-Networks;
    Resource-Location-Restriction-->IAM;
    Roles-->IAM;
    SCC-Findings-->SCC;
    SCC-Compliance-->SCC;
    SCC-Vulnerabilities-->SCC;
    VFW-->VPC-Networks;
    VPC-Flow-Logs-->VPC-Networks;
    VPC-Firewall-Logs-->VPC-Networks;
    Vulnerability-Scanning-->Artifact-Registry;
    
    %% service to gcp
    Artifact-Registry-->GCP;
    Cloud-Operations-Suite-->GCP;
    Cloud-Logging-->GCP;
    Cloud-Storage-->GCP;
    IAM-->GCP;
    Network-Security-->GCP;
    SCC-->GCP;
    Security-->GCP;
    VPC-Networks-->GCP{GCP};
    
    
```
### Pending
```mermaid
graph TD;
   
    AC-9-->pending;
    PS-6-->pending;
    IA-2.11-->pending;
    IA-5.6-->pending;
    SA-4-->pending;
    SA-8-->pending;
    SC-26-->pending;
  
    SI-3.7-->pending;
    SI-7-->pending;
  
```
[mermaid - diagrams as code](https://mermaid-js.github.io/mermaid/#/flowchart?id=graph)


## Security Controls
SA-4 marked KEY

Category / Count | Controls
 --- | ---  
AC _1_ | _AC-1_ 
SC _1_ | [SC-7](#6260sc-7boundary-protection)

### Mandatory 10 Security Controls 
```
20220921
10 security controls of high priority
AC-2 AC-17 CA-3 CM-7.5 IA-7 IR-4 IR-6 IR-9 SC-8 SC-12

List of above not in 31 subset below
AC-17 CM-7.5 IA-7 IR-4 (see existing IR-6) IR-9 SC-8 SC-12

List of above in TB subset below
SC-8. SC-12

List of above not in larger already evidenced list
- none

```



### Security Controls  - 31 subset
20220913: 31 subset of interest
```
5 AC-2 AC-3 AC-4 AC-6 AC-12
1 AT-3
4 AU-2 AU-3 AU-6 AU-13
1 CA-3
1 CM-2
2 IA-2 IA-5
1 IR-6
1 MP-2
2 PE-3 PE-19
1 PS-6
1 RA-5
2 SA-4 SA-8
5 SC-7 SC-13 SC-26 SC-28 SC-101
4 SI-2 SI-3 SI-4 SI-7
```

### Optional Security Controls - TB subset
There is overalap bewteen the 31 subset and the TB subset
TB specific:
```
AC-2.1/5/6.5/6.10/7/9/19/20.3
AU-8/9/9.4/12
CM-3/4/5/8
IA-2.1/2.2/2.11/4/5.1/5.6/5.7/5.13/6/8
SA-22
SC-5/7.5/8/8.1/12(p3?)/17/28/28.1
SI-3.7
```

### Extra security controls - via inheritance
Extras we have
```
AC-2.1
AC-5
AC-6.5
AC-6.10
AC-7
AC-17.1
CM-7.5
```


# Individual Security Controls

## legend
pk,control id,phase 1,phase 2, service name, service link, service evidence,code link, future, control link, title 

## 0020,AC-2,,,,,,,,,Account Management
P1 : (P1 is the priority number in the ITSG-33 document)
### GCP Services Coverage:
screen cap reference

### Definition: cloud identity super-admin root account with additional least-priv subaccounts

### Services: MFA, IAM roles/accounts - IAM Roles (org admin, billing admin, project admin, project billing admin), Identity Super Admin Role, ssh access, MFA on the identity account with optional AD federation

See Identity Onboarding and Federation options at https://cloud.google.com/architecture/landing-zones/decide-how-to-onboard-identities

Admin Group Account, Password Policy, Access Logs Event Logging, MFA, IAM Essential Contacts

### Violations
- L: Cloud Audit Logging should be configured properly across all services and all users from a project
- H: Cloud Storage buckets should not be anonymously or publicly accessible
- H: Datasets should not be publicly accessible by anyone on the internet


## 6260,SC-7,,,,,,,,,Boundary Protection
[P1](https://cyber.gc.ca/en/guidance/annex-3a-security-control-catalogue-itsg-33) : 

### Definition:
### GCP Services Coverage:
 - [IAM - Organization Policies - Resource Location Restriction](#iam---organization-policies---resource-location-restriction)
### Code Coverage
 - [05-data-location](#05-data-location)
### Services



## GCP Service to Controls Mappings : 1:N
# Google Cloud Services
Use the new "All Products" page for a list of Google Cloud Services https://console.cloud.google.com/products

## IAM
### IAM - Organization Policies
#### IAM - Organization Policies - Resource Location Restriction
##### Evidence
 - Security Controls covered: [SC-7](#6260sc-7boundary-protection)
 - Code: [05-data-location](#05-data-location)

###### Screencap
- ![img](img/evidence/_5590_iam_org_policy_resource_location_restriction_on_gr.png)
###### CLI
```
prep
export PROJECT_ID=pubsec-declarative-tk-lgz
export ORG_ID=$(gcloud projects get-ancestors $PROJECT_ID --format='get(id)' | tail -1)

verify org level
gcloud beta resource-manager org-policies list --organization $ORG_ID
CONSTRAINT: constraints/gcp.resourceLocations
LIST_POLICY: SET
BOOLEAN_POLICY: -

Verify specific policy
gcloud beta resource-manager org-policies describe gcp.resourceLocations --organization $ORG_ID

constraint: constraints/gcp.resourceLocations
etag: CMe_i5gGEKDVkL8D
listPolicy:
  allowedValues:
  - in:northamerica-northeast2-locations
  - in:northamerica-northeast1-locations
updateTime: '2022-08-22T01:45:43.937700Z'
```


##### Details
- see https://cloud.google.com/resource-manager/docs/organization-policy/defining-locations

## Controls to Code Mappings: M:N
### SC-7
- [05-data-location](#05-data-location)

## Code To Controls Mappings : 1:N
### environments
#### common
##### guardrails-policies
###### 05-data-location
- Artifact: [https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/landing-zone/environments/common/guardrails-policies/05-data-location](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/solutions/landing-zone/environments/common/guardrails-policies/05-data-location/constraint.yaml#L25)
- Control: [SC-7](#6260sc-7boundary-protection)



## Guardrails Subset
see - https://github.com/canada-ca/cloud-guardrails/tree/master/EN


# Links
  - detailed ITSG-33 (2014) https://cyber.gc.ca/en/guidance/annex-2-information-system-security-risk-management-activities-itsg-33
  - summary ITSG-33 https://cyber.gc.ca/en/guidance/annex-4-identification-control-elements-security-controls-itsg-41
  - AU-2 AU-3 AU-4 AU-5 AU-16 via cloud logging fedramp compliance https://cloud.google.com/blog/products/identity-security/5-must-know-security-and-compliance-features-in-cloud-logging
  - CSO https://www.tpsgc-pwgsc.gc.ca/esc-src/msc-csm/xa-eng.html
# Appendix
    
## Traffic Generation
