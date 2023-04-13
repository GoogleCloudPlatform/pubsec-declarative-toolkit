# Workload to common services

## Fortigate

1. Address Object for the spoke workload1 and for the common service - Could be available using the GCP SDN connector

    ```fortios
    config firewall address
        edit "project1-workload1-addr"
            set associated-interface "port2"
            set subnet 10.1.1.2 255.255.255.255
        next
        edit "service1-addr"
            set associated-interface "port2"
            set subnet 10.20.1.2 255.255.255.255
        next
    end
    ```

2. Firewall policy to allow traffic from port2/spoke resource to port2/common services

    ```fortios
    config firewall policy
        edit 0
            set name "allow workload1 to common services service1"
            set srcintf "port2"
            set dstintf "port2"
            set action accept
            # update with proper address object
            set srcaddr "project1-workload1-addr"
            # update with proper address object
            set dstaddr "service1-addr"
            set schedule "always"
            set service "HTTP"
            set utm-status enable
            set ssl-ssh-profile "certificate-inspection"
            set av-profile "default"
            set ips-sensor "default"
            set logtraffic all
            set comments "allow access from project-id workload1 to common services service1"
        next
    end
    ```

## Common Services VPC

1. firewall rule to allow ingress traffic from clients vpc to the service account or ip address of the PAZ connected resource

    ```yaml
    apiVersion: compute.cnrm.cloud.google.com/v1beta1
    kind: ComputeFirewall
    metadata:
      name: project-id-allow-workload1-http-to-service1-fwr # kpt-set: ${project-id}-allow-workload1-http-to-service1-fwr
      namespace: networking
      annotations:
        cnrm.cloud.google.com/project-id: project-id # kpt-set: ${project-id}
    spec:
      resourceID: allow-workload1-http-to-service1-fwr
      allow:
        - protocol: tcp
          ports:
          - "80"
      networkRef:
        name: project-id-global-vpc1-vpc # kpt-set: ${project-id}-global-vpc1-vpc
      sourceRanges:
      # update with ip from workload1
      - "10.1.1.2/32"
      targetServiceAccounts:
      - name: project-id-service1-sa # kpt-set: ${project-id}-service1-sa
    ```
