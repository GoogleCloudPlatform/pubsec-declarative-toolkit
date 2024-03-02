# Module feature: Public IP Addresses

This module supports both creating and attaching existing External IP addresses to the FortiGate cluster. External addresses can be then used for forwarding inbound connections from Internet to resources behind FortiGate firewalls and for source NAT for outbound connections from cloud to Internet.

Additionally, reserved external IP addresses will be attached to management ports (port4) of both FortiGate instances.

## Configuration

To configure External IP addresses pass them as a list in `frontends` variable. This variable accepts IPv4 IP for existing addresses and names for new addresses. You can mix existing and new addresses in the list, eg:

```
frontends = [
  "service1", # this will create a new address
  "service2", # this will create a new address
  "35.1.2.3"  # this will attach existing address
]
```

Non-existing, in-use and located in a different region addresses will be silently ignored.

## Applied changes

This module will:
 - create new regional External IP addresses for all entries not being an IP address
 - attach all new IP addresses to External Load Balancer (create new L3_DEFAULT forwarding rule)
 - attach all existing addresses to External Load Balancer (create new L3_DEFAULT forwarding rule)
 - configure all addresses as IP Pools in FortiGate configuration
 - configure all addresses as secondary-IP for port1 in FortiGate configuration with probe-response enabled

## Limitations

This module supports up to 32 public IP addresses. More public IP addresses can be added after deployment with probes configured using VIP+loopback method.
