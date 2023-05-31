# Security Controls

## Technical Controls - P1

### AC-4

- Deny all egress to spoke's IP, allow only connectivity to private GCP API endpoints. Hub will control traffic to other networks
- Separate subnets to segregate traffic
- Routing traffic through hub VPC
- VPC restricts subnets to Canadian region locations

### AU-3

- Enables DNS audit logging which is sent into the logging stream being captured by the logging project

### SC-7(C), SC-7(5)

- Deny all egress to spoke's IP, allow only connectivity to private GCP API endpoints. Hub will control traffic to other networks

## Technical Controls - P2

### AU-3(1)

- Enables DNS audit logging which is sent into the logging stream being captured by the logging project

## Technical Controls - P3

### SC-22

- Implement internal/external name resolution segregation, resolving GCP API queries to private endpoints. Uses GCP DNS functionality that is fault-tolerant

## Technical Controls - Undefined Priority

AC-4(21)

- Deny all egress to spoke's IP, allow only connectivity to private GCP API endpoints. Hub will control traffic to other networks
- Separate subnets to segregate traffic
- Routing traffic through hub VPC
- VPC restricts subnets to Canadian region locations
