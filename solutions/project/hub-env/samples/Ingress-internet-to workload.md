# Internet to workload

## GCP - External Load Balancer

1. TODO: Cloud Armor
1. External Load Balancer IP Reservation

    ```yaml
    apiVersion: compute.cnrm.cloud.google.com/v1beta1
    kind: ComputeAddress
    metadata:
      name: hub-elb-workload1-address
      namespace: networking
      annotations:
        cnrm.cloud.google.com/project-id: hub-project-id # kpt-set: ${hub-project-id}
    spec:
      resourceID: elb-workload1-address
      addressType: EXTERNAL
      location: northamerica-northeast1
      networkTier: PREMIUM # OR STANDARD
    ---
    ```

1. Forwarding Rule

    ```yaml
    apiVersion: compute.cnrm.cloud.google.com/v1beta1
    kind: ComputeForwardingRule
    metadata:
      name: hub-elb-workload1-fwdrule
      namespace: networking
      annotations:
        cnrm.cloud.google.com/project-id: hub-project-id # kpt-set: ${hub-project-id}
    spec:
      resourceID: elb-workload1-fwdrule
      ipAddress:
        addressRef:
          name: hub-elb-workload1-address
      ipProtocol: TCP
      loadBalancingScheme: EXTERNAL
      location: northamerica-northeast1
      networkTier: PREMIUM # OR STANDARD
      portRange: "80"
      target:
        targetVPNGatewayRef:
          name: hub-elb-pool
    ```

## Fortigate

1. Address object for external load balancer health check

    ```fortios
    config firewall vip
        edit "project1-workload1-healthcheck-vip"
            # update with external ip from reservation
            set extip 35.203.63.54
            # fortigate probe interface ip
            set mappedip "169.254.255.100"
            set extintf "port1"
            set portforward enable
            set extport 8008
            set mappedport 8008
        next
    end
    ```

2. Policy for external load balancer health check

    ```fortios
    config firewall policy
        edit 0
            set name "project1-workload1-healthcheck"
            set srcintf "port1"
            set dstintf "probe"
            set action accept
            set srcaddr "all"
            set dstaddr "project1-workload1-healthcheck-vip"
            set schedule "always"
            set service "PROBE"
            set comment "This policy forwards external load balancer health check to the probe loopback interface"
        next
    end
    ```

3. VIP object for workload1

    ```fortios
    config firewall vip
        edit "project1-workload1-vip"
            # update with external ip from reservation
            set extip 35.203.63.54
            # update with workload1 ip
            set mappedip "10.1.1.2"
            set extintf "port1"
            set portforward enable
            set extport 80
            set mappedport 80
        next
    end
    ```

3. Firewall policy to allow traffic from VIP to Spoke's PAZ address

    ```fortios
    config firewall policy
        edit 0
            set name "internet to workload1"
            set srcintf "port1"
            set dstintf "port2"
            set action accept
            set srcaddr "all"
            # update with proper address object
            set dstaddr "project1-workload1-vip"
            set schedule "always"
            set service "HTTP"
            set utm-status enable
            set ssl-ssh-profile "certificate-inspection"
            set av-profile "default"
            set ips-sensor "default"
            set application-list "default"
            set logtraffic all
            set comments "allow access from internet to project-id workload1"
        next
    end
    ```

## GCP - Spoke VPC

1. Firewall rule to allow ingress traffic from internet to the service account or ip address of the PAZ connected resource

    ```yaml
    apiVersion: compute.cnrm.cloud.google.com/v1beta1
    kind: ComputeFirewall
    metadata:
      name: project-id-allow-http-to-workload1-fwr # kpt-set: ${project-id}-allow-http-to-workload1-fwr
      namespace: networking
      annotations:
        cnrm.cloud.google.com/project-id: project-id # kpt-set: ${project-id}
    spec:
      resourceID: allow-http-to-workload1-fwr
      allow:
        - protocol: tcp
          ports:
          - "80"
      networkRef:
        name: project-id-global-vpc1-vpc # kpt-set: ${project-id}-global-vpc1-vpc
      sourceRanges:
      - "0.0.0.0/0"
      targetServiceAccounts:
      - name: project-id-workload1-sa # kpt-set: ${project-id}-workload1-sa
    ```
