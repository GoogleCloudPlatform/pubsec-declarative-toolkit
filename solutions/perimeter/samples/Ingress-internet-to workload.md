# Internet to workload

## GCP - External Load Balancer
1. TODO: Cloud Armor
1. External Load Balancer IP Reservation
    ```yaml
    apiVersion: compute.cnrm.cloud.google.com/v1beta1
    kind: ComputeAddress
    metadata:
      name: perimeter-elb-workload1-address
      namespace: networking
      annotations:
        cnrm.cloud.google.com/project-id: perimeter-project-id # kpt-set: ${perimeter-project-id}
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
      name: perimeter-elb-workload1-fwdrule
      namespace: networking
      annotations:
        cnrm.cloud.google.com/project-id: perimeter-project-id # kpt-set: ${perimeter-project-id}
    spec:
      resourceID: elb-workload1-fwdrule
      ipAddress:
        addressRef:
          name: perimeter-elb-workload1-address
      ipProtocol: TCP
      loadBalancingScheme: EXTERNAL
      location: northamerica-northeast1
      networkTier: PREMIUM # OR STANDARD
      portRange: "80"
      target:
        targetVPNGatewayRef:
          name: perimeter-elb-pool
    ```

## Fortigate

1. Port1 IP with probe-response access
    ```fortios
    config system interface
        edit "port1"
            set secondary-IP enable
            config secondaryip
                edit 0
                    # update with external ip from reservation
                    set ip 35.203.63.54 255.255.255.255
                    set allowaccess probe-response
                next
            end
        next
    end
    ```
2. VIP object
    ```fortios
    config firewall vip
        edit "project1-workload1"
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
            set dstaddr "project1-workload1"
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
1. Firewall rule to allow ingress trafic from internet to the service account or ip adress of the PAZ connected resource
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