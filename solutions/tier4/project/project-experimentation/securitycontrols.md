# 30 days Guardrail

<https://github.com/canada-ca/cloud-guardrails>

## Guardrail 1 -  Master account should be secured

* n/a to this package

## Guardrail 2 - Global Admins should be secured

* AC-3(7) - ACCESS ENFORCEMENT | ROLE-BASED ACCESS CONTROL :
    Role policies for accounts are being set in this package. The "Editor" and "IAM Security Admin" roles are granted at the project scope to a customizable user, group or service account through `setters.yaml`.

## Guardrail 4 - CBS access to billing should be granted

* n/a to this package

## Guardrail 8 - Network segmentation should be configured

* AC‑4 - INFORMATION FLOW ENFORCEMENT

    Default route to the Internet is removed, and replaced with one requiring specific tagging to pass traffic (no unintentional access to the Internet). Implements 3 zones as per ITSG-22, no default communications are enabled between them (specific firewall rules will need to be created based on need). Logging enabled.

* SC‑7 - BOUNDARY PROTECTION:

    This package implements ITSG-22 zoning with a PAZ, an APPRZ and a DATARZ subnet. It enables workload placement as per ITSG-38.

* SC‑7(5) -BOUNDARY PROTECTION | DENY BY DEFAULT / ALLOW BY EXCEPTION:

    GCP VPC comes with default ingress deny all rule and a default egress allow all rule. This package replaces the default route to access the internet with a default route that requires that resources configure a network tag "internet-egress-route" to be able to access the internet. This implements "deny by default" for internet access.

## Guardrail 12 - Marketplace should be locked down to only approved software

* n/a to this package
