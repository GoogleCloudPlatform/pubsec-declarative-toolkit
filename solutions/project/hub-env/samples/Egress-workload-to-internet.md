# Workload to Internet

## Fortigate

1. Address Object for the spoke resource - Could be available using the GCP SDN connector

    ```fortios
    config firewall address
        edit "project1-workload1-addr"
            set associated-interface "port2"
            # update with workload1 ip
            set subnet 10.1.1.2 255.255.255.255
        next
    end
    ```

1. Web Filter profile allowing the required whitelist
    - urlfilter: only allow access to packages.cloud.google.com, *.ubuntu.com,*.debian.org

      ```fortios
      config webfilter urlfilter
          edit 1
              set name "linux packages update"
              config entries
                  edit 1
                      set url "packages.cloud.google.com"
                      set type simple
                      set action allow
                  next
                  edit 2
                      set url "*.ubuntu.com"
                      set type wildcard
                      set action allow
                  next
                  edit 3
                      set url "*.debian.org"
                      set type wildcard
                      set action allow
                  next
                  edit 4
                      set url "*"
                      set type wildcard
                      set action block
                  next
              end
          next
      end
      ```

    - build web filter profile

      ```fortios
      config webfilter profile
          edit "whitelist"
              config web
                  # reference the urlfilter created above
                  set urlfilter-table 1
              end
          next
      end
      ```

1. Firewall policy to allow traffic from port2/spoke resource to port1/internet
   - SPOKE PAZ resources - direct connection

      ```fortios
      config firewall policy
          edit 0
              set name "allow workload1 to internet"
              set srcintf "port2"
              set dstintf "port1"
              set action accept
              # update with proper address object
              set srcaddr "project1-workload1-addr"
              set dstaddr "all"
              set schedule "always"
              set service "HTTP" "HTTPS"
              set utm-status enable
              set ssl-ssh-profile "certificate-inspection"
              set webfilter-profile "whitelist"
              set logtraffic all
              # NAT will use port1 ip
              set nat enable
              set comments "allow access from project-id workload1 to internet with urlfilter"
          next
      end
      ```

   - SPOKE APPRZ and DATARZ resources - proxy connection

      ```fortios
      config firewall proxy-policy
          edit 0
              set name "allow workload1 to internet"
              set proxy explicit-web
              set dstintf "port1"
              set srcaddr "project1-workload1-addr"
              set dstaddr "all"
              set service "webproxy"
              set action accept
              set schedule "always"
              set logtraffic all
              set utm-status enable
              set ssl-ssh-profile "certificate-inspection"
              set webfilter-profile "whitelist"
              set comments "allow access from project-id workload1 to internet with urlfilter"
          next
      end
      ```
