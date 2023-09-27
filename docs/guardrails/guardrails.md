## Protect root / global admins account(s) with Multi-Factor Authentication

### Enforce uniform MFA to company-owned resources [MFA][]

Protect your user accounts and company data with a wide variety of MFA verification methods such as push notifications, Google Authenticator, phishing-resistant [Titan Security Keys](https://cloud.google.com/titan-security-key), and using your Android or iOS device as a security key.  If Cloud Identity is your identity provider (IdP), you can implement 2SV in several ways. If you use a third-party IdP, check with them about their 2SV offering.

You can select different levels of 2SV enforcement:
- Optional—employee decides if they will use 2SV.
- Mandatory—employee chooses the 2SV method.
- Mandatory security keys—employee must use a security key.

### **Validation**
As your organization's administrator, you can monitor your users' exposure to data compromise by opening a security report. The security report gives you a comprehensive view of how people share and access data and whether they take appropriate security precautions. You can also see who installs external apps, shares a lot of files, skips 2-Step Verification, uses security keys, and more. 

### **Open your Security Report**
- Access [admin.google.com](https://admin.google.com)
- Select Reports
- Select App Reports or User Reports
- Select Accounts

![alt text](../images/mfa.png "Enable MFA Screenshot")

Reports can be customized to include *password length compliance, password strength, admin status* amongst many other attributes

![alt text](../images/reports.png)

[MFA](https://cloud.google.com/identity/solutions/enforce-mfa)

## Management of Administrative Privileges

### Establish access control policies and procedures for management of administrative privilege

The majority of this guardrail will be managed with existing Government of Canada identity provider (IdP). For Granting, changing, and revoking access to resources you can leverage Identity and Access Management (IAM) and details can be found here [Managing Roles and Permissions](https://cloud.google.com/iam/docs/granting-changing-revoking-access).

Google Cloud security best practices [Security Best Pratices](https://cloud.google.com/security/best-practices)

## Cloud Console Access

### Limit access to GC managed devices and authorized users

This will be managed with existing Government of Canada identity provider (IdP).

- Acces Context Manager and Beyond Corp
- 
 ## 04 - Enterprise Monitoring Accounts

### Create role-based account to enable enterprise monitoring and visibility

Created as part of the core landing zone package.

## Data Location 

### Establish policies to restrict GC sensitive workloads to approved geographic locations


The deployment template provides variables to set defaults. One of the variables is default_region which defines the default region to create resources. By setting the default to Montreal which is northamerica-northeast1 then the resource creation will be restricted to only that region. For details on the template please see [Bootstrap Template](https://github.com/terraform-google-modules/terraform-example-foundation/tree/master/0-bootstrap)

    
### Restricting Resource on the entire Organization<BR>
You can also choose to provide an Organization Policy which would restrict any future resource creation for the entire organization. You can find details on this option here [Restricting  Resource Location]("https://cloud.google.com/resource-manager/docs/organization-policy/defining-locations")
    

### **Validation**
The validation template will search the entire Cloud Asset Inventory for any resources that are not located on the default region

# Encryption at rest in Google Cloud

### Comprehensive Encryption at rest Information: [Encryption at Rest Whitepaper][]

<a href="https://www.youtube.com/watch?v=Svz2KHE1mdM&autoplay=1"><p align = "center"><img src="../images/video-at-rest.png" width="300"></img></p></a>

## **Google's default encryption**

### **Encryption of data at rest**
Google Cloud Platform **encrypts all customer data at rest without any action required from you**, the customer.Google Cloud Platform encrypts all customer data at rest without any action required from you, the customer.   Google uses a common cryptographic library, Keyczar, to implement encryption consistently across almost all Google Cloud Platform products.  This includes data stored in cloud storage, computer engine persistent disks, cloud SQL databases, virtually everything.

### **Layers of Encryptions**
Google uses several layers of encryption to protect data. Using multiple layers of encryption adds redundant data protection and allows us to select the optimal approach based on application requirements.

<p align = "center"><img src="../images/encryption-layers.png" width="500"></img></p>

All data stored in GCP is encrypted with a unique data encryption key (DEK).  More specifically, data is then broken into sub-file chunks for storage. Each chunk can be up to several gigabytes in size. Each chunk of data is then encrypted at the storage level with a unique key.  Two chunks will not have the same encryption key even if they are part of the same Google Cloud storage object owned by the same customer or stored on the same machine.

<p align = "center"><img src="../images/encrypted-data.png" width="500"></img></p>

Encrypted data chunks are then distributed across Google's storage infrastructure.
This partition of data, each using a different key, means that the blast radius of a potential encryption key compromise is limited to only that data chunk. The data encryption keys are encrypted with or wrapped by key encryption keys or KEKs.
The wrapped data encryption keys are then stored with this data. The key encryption keys are exclusively stored and used inside Google's central Key Management Service or KMS.  KMS held keys are also backed up for disaster recovery purposes and are indefinitely recoverable. 

Decrypting data requires the unwrapped data encryption key, DEK, for that data chunk. When a Google Cloud Platform service accesses an encrypted chunk of data: For each chunk the storage system pulls the wrapped DEK stored for that chunk and calls a Google Key Management Service to retrieve the unwrapped data encryption key for that data chunk. The KMS then passes the unwrapped DEK back to the storage system which is then able to decrypt the data chunk.

***By default this entire process is enabled by default and is fully managed by Google, including the key encryption keys. There is absolutely nothing to enable or configure.***

Google also manages the key rotation schedule. This schedule varies slightly depending on the service, but the standard rotation period for KEKs is every 90 days. 

**Encryption at rest options include:**
- Encryption by default
- Customer-managed encryption keys (CMEK) using Cloud KMS
- Customer-supplied encryption keys (CSEK)


[Encryption at Rest Whitepaper]: https://cloud.google.com/security/encryption-at-rest/default-encryption

# Encryption in Transit in Google Cloud

### Comprehensive In-Transit Encryption Method Information: [Encryption In-Transit Whitepaper][]

<a href="https://www.youtube.com/watch?v=Svz2KHE1mdM&autoplay=1"><p align = "center"><img src="../images/video-in-transit.png" width="300"></img></p></a>


GCP uses a FIPS 140-2 validated module called BoringCrypto (certificate 2964) in our production environment. This means that data in transit to the customer and between data centers as well as data at rest is encrypted using FIPS 140-2 validated cryptography. The module that achieved FIPS 140-2 validation is part of our BoringSSL library. All regions and zones currently support FIPS 140-2 mode.

## **Encryption in Transit by Default**
Google encrypts and authenticates all data in transit at one or more network layers when data moves outside the physical boundaries controlled by Google.  Google uses various methods of encryption, both default and user configurable, for data in transit.  The type of encryption used depends on the OSI layer, the type of service and the physical component of the infrastructure.  The figures below illustrate the optional and default protections Google Cloud has in place for layers 3, 4 and 7

- **Protection by Default and Options at Layer 3 & 4 across Google Cloud**
<p align = "center"><img src="../images/encryption-by-default-1.svg" width="700"></img></p>

- **Protection by Default and Options at Layer 7 across Google Cloud**
<p align = "center"><img src="../images/encryption-by-default-2.svg" width="700"></img></p>

Diagram below further depicts protection by default and options overlaid on Google Networking depending on five kinds of routing requests:
1. End user (Internet) to Google Cloud Service
2. End user (Internet) to a customer application hosted on Google Cloud
3. Virtual Machine to Virtual Machine
4. Virtual Machine to Google Cloud Service
5. Google Cloud Service to Google Cloud Service

<p align = "center"><img src="../images/protection-by-default.svg" width="600"></img></p>


### **Ongoing Innovation in Encryption in Transit**
Google plans to remain the industry leader in encryption in transit. To this end, we have started work in the area of post-quantum cryptography. This type of cryptography allows us to replace existing crypto primitives, that are vulnerable to efficient quantum attacks, with post-quantum candidates that are believed to be more robust. For more information, please refer to: https://cloud.google.com/security/encryption-in-transit#chrome_security_user_experience 




[Encryption In-Transit Whitepaper]: https://cloud.google.com/security/encryption-in-transit

## 08 - Segment and Separate

### Segment and separate information based on sensitivity of information

The creation of network infrastructure will be handled through the [accelerator templates](https://github.com/canada-ca/accelerators_accelerateurs-gcp).

## 09 - Network Security Services

### Establish external and internal network perimeters and monitor network traffic

This is handled by Security Foundations Blueprints 

## 10 - Cyber Defense Services

## Guardrail # 11 Logging and Monitoring

### Enable logging for the cloud environment and for cloud-based workloads.

In order to comply with this guardrail we will validate that a log sink asset and storage bucket is created for capturing platform logs.

##  Configuration of Cloud Marketplaces

### Restrict Third-Party CSP Marketplace software to GC-approved products

### Private Catalog
To restrict the available solutions to only GC-approved solutions you need to create a private catalog and add solutions to the private catalog. Private Catalogs are where administrators have control over what solutions are available i.e whitelist. Please follow this [quickstart guide](https://cloud.google.com/private-catalog/docs/quickstart)

These links also provide more details on private catalog:<br>
- [Overview of Private Catalog](https://cloud.google.com/private-catalog/docs)
- [Creating a solution from Cloud Marketplace](https://cloud.google.com/private-catalog/docs/marketplace-products)
- [Access Controls](https://cloud.google.com/private-catalog/docs/access-control)
- [Sharing the catalog](https://cloud.google.com/private-catalog/docs/share-catalog)

### Public Marketplace

Google Cloud also provides Public Marketplace which requires permissions to deploy solutions. Departments do not control what is available in the public marketplace. But by default without the right permissions users cannot deploy solutions from the public marketplace. We suggest that you assign the Billing Administrator (roles/billing.admin) IAM role if you want users to purchase services from Public Cloud Marketplace. For details on access controls for Public Marketplace please see [Access Controls](https://cloud.google.com/marketplace/docs/access-control). 

### Validation
The validation Guardrail will identify users who should not have the permissions required.
