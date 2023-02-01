1. add org policy exception for vm with public ip AND serial console access
force instance nic to be gvnic
ha - disable session pickup
set default route on multi nic GCE

## Fortigate
1. add route for ip range of all peered vpc (ex. : 10.0.0.0/8) and define the internal gateway ip (ex. : 172.31.201.1) as the gateway
![route](route.png)

1. add firewall policy to allow traffic
![policies](policies.png)

1. update time zone to be gmt-5
![settings](settings.png)

# setters :
  perimeter-project-id
  fortigate admin pw
  fortigate ha pw
  schedule for secondary fortigate