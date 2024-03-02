## MULTI_IP_SUBNET scheme

**NOTE: this article is outdated as MULTI_IP_SUBNET support was removed from gcloud and from terraform. As of today it's still available for deployment manager templates and direct API calls. MULTI_IP_SUBNET is now only supported when creating images.**

MULTI_IP_SUBNET is a “guest OS feature” flag, which can be enabled when creating the VM using

the command line:
```
gcloud compute instances create …
  --guest-os-features MULTI_IP_SUBNET
```

Deployment Manager template:
```
- type: compute.v1.instance
  properties:
    disks:
    - boot: true
      guestOsFeatures:
      - type: MULTI_IP_SUBNET
```

or Terraform.

You can verify if your instance was created using this option by clicking *Equivalent REST* at the bottom of the VM Instance details page or by describing the instance using gcloud command.

MULTI_IP_SUBNET scheme makes it easier to configure routing in FortiGate instances as it allows to use the subnet configuration known from on-premise networks, where the interface IP is configured with subnet’s  full netmask (instead of 255.255.255.255) and static routes configuration in FortiGate is needed only for the CIDRs not directly connected to the firewall.

Sample FortiGate configuration with MULTI_IP_SUBNET:
```
config system interface
  edit port1
    set mode static
    set ip 192.168.0.2/24
  next
end
config router static
  edit 1
    set dst 0.0.0.0/0
    set device port1
    set gateway 192.168.0.1
  next
end
```

Sample FortiGate configuration without MULTI_IP_SUBNET:
```
config system interface
  edit port1
    set mode static
    set ip 192.168.0.2/32
  next
end
config router static
  edit 1
    set dst 0.0.0.0/0
    set device port1
    set gateway 192.168.0.1
  next
  edit 2
    set dst 192.168.0.0/24
    set device port1
    set gateway 192.168.0.1
  next
end
```
