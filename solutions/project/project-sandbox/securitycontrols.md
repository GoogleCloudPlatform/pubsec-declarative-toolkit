# 30 days Guardrail
https://github.com/canada-ca/cloud-guardrails

## Guardrail 1 -  Master account should be secured
* n/a to this package

## Guardrail 2 - Global Admins should be secured
* AC-3(7) - Role policies for accounts are being set in this package. The "Editor" role is granted to a customizable user, group or service account.

## Guardrail 4 - CBS access to billing should be granted
* n/a to this package

## Guardrail 8 - Network segmentation should be configured
* AC‑4 - INFORMATION FLOW ENFORCEMENT
    
    TBD

* SC‑7 - BOUNDARY PROTECTION:
  
    This package implements ITSG-22 zoning with a PAZ, an APPRZ and a DATARZ subnet. It enables workload placement as per ITSG-38.

* SC‑7(5) -BOUNDARY PROTECTION | DENY BY DEFAULT / ALLOW BY EXCEPTION:

    GCP VPC comes with default ingress deny all rule and a default egress allow all rule. This package replaces the default route to access the internet with a default route that requires that resources configure a network tag "internet-route" to be able to access the internet. This implement "deny by default" for internet access.

## Guardrail 12 - Marketplace should be locked down to only approved software
* n/a to this package