# Google Cloud Resources Addendum

- [Google Cloud Resources Addendum](#google-cloud-resources-addendum)
  - [Fun Links](#fun-links)
  - [Config Controller](#config-controller)
  - [Policy Controller](#policy-controller)
  - [Config Sync](#config-sync)
    - [Tools and Utilities](#tools-and-utilities)
  - [kpt](#kpt)
  - [DNS](#dns)
    - [General DNS knowledge](#general-dns-knowledge)
    - [GCP DNS Key Terms](#gcp-dns-key-terms)
    - [Google Cloud Specific Documentation](#google-cloud-specific-documentation)
    - [DNS Zones](#dns-zones)
    - [Internal DNS](#internal-dns)
    - [Private Zones](#private-zones)
      - [Options](#options)
    - [Public, External DNS Zone](#public-external-dns-zone)
      - [Anycast Resolution](#anycast-resolution)
    - [Cross Project Binding](#cross-project-binding)
  - [Cloud Armor](#cloud-armor)
    - [Cloud Armour Encompasses](#cloud-armour-encompasses)
    - [Cloud Armor Policies \& Ordering](#cloud-armor-policies--ordering)
    - [How it works](#how-it-works)
    - [Example Policy Scopes](#example-policy-scopes)
    - [Cloud Armor Documentation of Interest](#cloud-armor-documentation-of-interest)
  - [Cloud Load Balancing](#cloud-load-balancing)
  - [Firewall Rules Creation](#firewall-rules-creation)
  - [VPC Service Controls](#vpc-service-controls)
    - [Quick Start](#quick-start)
    - [General information](#general-information)
  - [Remote Access with IAP](#remote-access-with-iap)
    - [IAP access into a windows VM](#iap-access-into-a-windows-vm)

--------------------------------------

## Fun Links

Enjoy!

The ultimate [infographic on GCP products](https://googlecloudcheatsheet.withgoogle.com/) for Developers

Check your regions latency using [GPCping](https://gcping.com/)

## Config Controller

[Config Controller Overview](https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-overview)

Config Controller provides a managed control plane, based on Kubernetes. In addition, Config Controller instances come pre-installed with Policy Controller, Config Sync, and Config Connector. By using these components, you can leverage the tools and workflows of Kubernetes to manage Google Cloud resources and achieve consistency by using a GitOps workflow.
To learn more, see the Config Controller overview.

## Policy Controller

[Policy Controller Overview](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller)

Policy Controller enables the enforcement of fully programmable policies for your clusters. These policies act as "guardrails" and prevent any changes to the configuration of the Kubernetes API from violating security, operational, or compliance controls.
You can set policies to actively block non-compliant API requests, or simply to audit the configuration of your clusters and report violations. Policy Controller is based on the open source Open Policy Agent Gatekeeper - [OPA](https://open-policy-agent.github.io/gatekeeper/website/docs/operations/) project and comes with a full library of pre-built policies for common security and compliance controls.
In addition to actively controlling your Kubernetes environment, you can optionally use Policy Controller as a way to analyze configuration for compliance before deployment. This helps provide valuable feedback during the process of configuration changes and ensures any non-compliant changes are caught early before they might be rejected during application.

## Config Sync

[Config Sync Overview](https://cloud.google.com/anthos-config-management/docs/config-sync-overview)

Config Sync is a GitOps service offered as a part of Anthos. Config Sync is built on an open source core and lets cluster operators and platform administrators deploy configurations from a source of truth. The service has the flexibility to support one or many clusters and any number of repositories per cluster or namespace. The clusters can be in a hybrid or multi-cloud environment.

Config Sync continuously reconciles the state of Config Controller with files stored in one or more Git repositories. This GitOps strategy lets you manage and deploy common configurations with a process that is auditable, transactional, reviewable, and version-controlled.

Getting started with [Config Sync](https://cloud.google.com/anthos-config-management/docs/tutorials/config-sync-multi-repo)

### Tools and Utilities

[Nomos](https://cloud.google.com/anthos-config-management/docs/how-to/nomos-command)
[Kubectl](https://cloud.google.com/anthos-config-management/docs/how-to/configure-config-sync-kubectl)

## kpt

[KPT Readme.md](https://github.com/GoogleContainerTools/kpt/#readme) is an open source project used to hydrate yaml, get packages, apply functions, search and replace in yaml manifests. kpt is a package centric toolchain that enables a WYSIWYG configuration authoring and authoring enabling tool.

kpt [installation](https://kpt.dev/installation/)

kpt [functions catalog](https://catalog.kpt.dev/?id=curated-functions-catalog)

**Important:**  Please note that kpt is available through the gcloud components, however you may wish to use a specific version, or newer version than that is provided by the gcloud SDK.

## DNS

[DNS Overview](https://cloud.google.com/dns/docs/dns-overview)

High level overview of some of the Google Cloud resource types to accelerate the design and deployment of your *workload*.

### General DNS knowledge

- DNS server types *(Authoritative, Recursive)*
- Zones *(Public, Private, Delegated, Split brain/horizon)*
- Records *(A, AAAA, Cname, Mx, NS, PTR, SOA)*

### GCP DNS Key Terms

[Key Terms](https://cloud.google.com/dns/docs/key-terms)

### Google Cloud Specific Documentation

[Cloud DNS Overview](https://cloud.google.com/dns/docs/overview/)

[Cloud Domains Overview](https://cloud.google.com/domains/docs/overview)

### DNS Zones

### Internal DNS

Internal DNS names are names that Google Cloud creates automatically. Available in a single VPC by default, resolved by the metadata server (169.254.169.254). Google Cloud automatically creates, updates, and removes these DNS records. Please see [Internal DNS zone documentation](https://cloud.google.com/compute/docs/internal-dns).

### Private Zones

Managed custom domain names for virtual machines and other GCP resources without exposing the DNS data to the public internet. Please see [Private Zone Documentation](https://cloud.google.com/dns/docs/zones#create-private-zone).

Unless you have specified an alternative name server in an outbound server policy, Google Cloud first attempts to find a record in a private zone (or forwarding zone or peering zone) authorized for your VPC network before it looks for the record in a public zone.

#### Options

- [Forward Queries to another server](https://cloud.google.com/dns/docs/zones/forwarding-zones)
- [DNS Peering](https://cloud.google.com/dns/docs/zones/peering-zones)
- [Managed Reverse Lookup Zone](https://cloud.google.com/dns/docs/zones/managed-reverse-lookup-zones)

### Public, External DNS Zone

Create DNS records in public zones to publish your service on the internet. Please see [Public Zone Documentation](https://cloud.google.com/dns/docs/dns-overview#public_zone).

#### Anycast Resolution
>>
>> Google DNS has some fame associated to it for it's resiliency and global availability properties, with publicly available resolvers such as:
>>> 8.8.8.8
>>> 8.8.8.4

These resolvers are *anycast addresses* with requests being routed to the nearest location advertising the address.

### Cross Project Binding

Cross project binding is used to manage private DNS zones that service another project in the same organization.

[Cross project binding Overview](https://cloud.google.com/dns/docs/zones/zones-overview#cross-project_binding)
[Creating a Zone with cross project binding](https://cloud.google.com/dns/docs/zones/cross-project-binding)

## Cloud Armor

[Cloud Armor Overview](https://cloud.google.com/armor/docs/cloud-armor-overview)

Google Cloud Armor is a DDoS and application defense service the helps protect your *service*. Cloud Armor is tightly coupled with the Global HTTPS(S) Cloud Load Balancer. Cloud Armor protects your network services, typically behind a load balancer from DOS and other web based attacks. Enforcement is managed at the edge Point of Presence (POP), as close to the source traffic as possible. Traffic can be filtered and defended against at layer 7 of the OSI model.

### Cloud Armour Encompasses

- Policies/Rules
- Allowlist / Denylist IP's

### Cloud Armor Policies & Ordering

- Rules (allow) [Priority 1]
- Rules (Deny) [Priority 2]

### How it works

- Create a policy with +1 rules
  - Supply IP range(s) to apply rule to
  - On rule/IP match: Allow/Deny traffic
    - Overlap rules with different priorities
  - Apply policy to Targets
    - Target = Load balanced backend services

### Example Policy Scopes

- Create multiple rules, overlapping to create finer grained rules.
- SQL Injection Prevention (CSS), Geo based access control.
- Allows edge traffic blocking.

### Cloud Armor Documentation of Interest

[Use cases](https://cloud.google.com/armor/docs/common-use-cases)
[Security Policies](https://cloud.google.com/armor/docs/configure-security-policies#https-load-balancer)
[Rules Language Reference](https://cloud.google.com/armor/docs/rules-language-reference)
[Cloud Armor Standard VS Managed Protection Plus](https://cloud.google.com/armor/docs/managed-protection-overview#standard_versus_plus)

## Cloud Load Balancing

[Cloud Load Balancing Overview](https://cloud.google.com/load-balancing/docs/load-balancing-overview)

A load balancer distributes user traffic across multiple instances of your applications. By spreading the load, load balancing reduces the risk that your applications experience performance issues.
Cloud Load Balancing is a fully distributed, software-defined managed service. It isn't hardware-based, so you don't need to manage a physical load-balancing infrastructure.

Google Cloud offers the following load-balancing features:

- Single anycast IP address
- Software-defined load balancing
- Seamless autoscaling
- Layer 4 and Layer 7 load balancing
- External and internal load balancing
- Global and regional load balancing
- Advanced feature support

## Firewall Rules Creation

[VPC Firewall Rules Overview](https://cloud.google.com/vpc/docs/firewalls)

Virtual Private Cloud (VPC) firewall rules apply to a given project and network.
VPC firewall rules let you allow or deny connections to or from virtual machine (VM) instances in your VPC network. Enabled VPC firewall rules are always enforced, protecting your instances regardless of their configuration and operating system, even if they have not started up.

## VPC Service Controls

[VPC Service Controls Overview](https://cloud.google.com/vpc-service-controls/docs/overview)

*Important* [Terminology](https://cloud.google.com/vpc-service-controls/docs/overview#terminology)

A service perimeter creates a security boundary around Google Cloud resources. You can configure a perimeter to control communications from virtual machines (VMs) to a Google Cloud service (API), and between Google Cloud services. A perimeter allows free communication within the perimeter but, by default, blocks communication to Google Cloud services across the perimeter. The perimeter does not block access to any third-party API or services in the internet. [Reference doc.](https://cloud.google.com/vpc-service-controls/docs/overview#isolate)

### Quick Start

[Learn](https://cloud.google.com/vpc-service-controls/docs/set-up-service-perimeter) how to set up a service perimeter using VPC Service Controls in the Google Cloud console.

### General information

VPC service controls allow blocking or restriction of api services at the Project or VPC network level

- Protects against data exfiltration
- Create a perimeter
  - Apply to a Project
  - Add services to restrict such as the storage API

[Access Context Levels](https://cloud.google.com/vpc-service-controls/docs/use-access-levels)

## Remote Access with IAP

### IAP access into a windows VM

IAP Desktop is a Windows application that lets you manage multiple Remote Desktop connections to Windows VM instances. IAP Desktop connects to VM instances by using Identity-Aware Proxy TCP forwarding and does not require VM instances to have a public IP address.
Before you connect by using IAP Desktop, make sure that the following prerequisites are met:

- You've configured your VPC to allow IAP traffic to your VM instance.
- You've downloaded and installed IAP Desktop on your local computer.

[IAP TCP Forwarding Overview](https://cloud.google.com/iap/docs/tcp-forwarding-overview)

IAP's TCP forwarding feature lets you control who can access administrative services like SSH and RDP on your backends from the public internet. The TCP forwarding feature prevents these services from being openly exposed to the internet. Instead, requests to your services must pass authentication and authorization checks before they get to their target resource.
