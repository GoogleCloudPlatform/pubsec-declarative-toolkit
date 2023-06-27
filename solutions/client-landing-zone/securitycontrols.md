# Security Controls

<!-- BEGINNING OF SECURITY CONTROLS LIST -->
|Security Control|File Name|Resource Name|
|---|---|---|
|AC-3(7)|./client-folder/folder-iam.yaml|clients.client-name-client-folder-viewer-permissions|
|AC-3(7)|./logging-project/project-iam.yaml|platform-and-component-log-client-name-bucket-writer-permissions|
|AC-4|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-default-egress-deny-fwr|
|AC-4|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-egress-allow-all-internal-fwr|
|AC-4|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/firewall.yaml|host-project-id-standard-egress-allow-psc-fwr|
|AC-4|./client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml|host-project-id-nane1-standard-nonp-main-snet|
|AC-4|./client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml|host-project-id-nane1-standard-pbmm-main-snet|
|AC-4|./client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml|host-project-id-nane2-standard-nonp-main-snet|
|AC-4|./client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml|host-project-id-nane2-standard-pbmm-main-snet|
|AC-4|./client-folder/standard/applications-infrastructure/host-project/network/vpc.yaml|host-project-id-global-standard-vpc|
|AC-4|./client-folder/standard/applications-infrastructure/host-project/network/vpc.yaml|host-project-id-global-standard-vpc|
|AC-4(21)|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-default-egress-deny-fwr|
|AC-4(21)|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-egress-allow-all-internal-fwr|
|AC-4(21)|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/firewall.yaml|host-project-id-standard-egress-allow-psc-fwr|
|AC-4(21)|./client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml|host-project-id-nane1-standard-nonp-main-snet|
|AC-4(21)|./client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml|host-project-id-nane1-standard-pbmm-main-snet|
|AC-4(21)|./client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml|host-project-id-nane2-standard-nonp-main-snet|
|AC-4(21)|./client-folder/standard/applications-infrastructure/host-project/network/subnet.yaml|host-project-id-nane2-standard-pbmm-main-snet|
|AC-4(21)|./client-folder/standard/applications-infrastructure/host-project/network/vpc.yaml|host-project-id-global-standard-vpc|
|AU-11|./logging-project/cloud-logging-bucket.yaml|platform-and-component-client-name-log-bucket|
|AU-11|./setters.yaml|setters|
|AU-12(A)|./client-folder/folder-sink.yaml|platform-and-component-log-client-name-log-sink|
|AU-12(C)|./client-folder/folder-sink.yaml|platform-and-component-log-client-name-log-sink|
|AU-2|./client-folder/folder-sink.yaml|platform-and-component-log-client-name-log-sink|
|AU-4(1)|./logging-project/cloud-logging-bucket.yaml|platform-and-component-client-name-log-bucket|
|AU-9|./logging-project/cloud-logging-bucket.yaml|platform-and-component-client-name-log-bucket|
|AU-9|./setters.yaml|setters|
|AU-9(2)|./logging-project/cloud-logging-bucket.yaml|platform-and-component-client-name-log-bucket|
|SC-22|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml|host-project-id-standard-gcrio-dns|
|SC-22|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml|host-project-id-standard-gcrio-rset|
|SC-22|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml|host-project-id-standard-gcrio-wildcard-rset|
|SC-22|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml|host-project-id-standard-googleapis-dns|
|SC-22|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml|host-project-id-standard-googleapis-rset|
|SC-22|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/dns.yaml|host-project-id-standard-googleapis-wildcard-rset|
|SC-22|./client-folder/standard/applications-infrastructure/host-project/network/public-dns.yaml|client-name-standard-core-public-dns-ns-rset|
|SC-22|./client-folder/standard/applications-infrastructure/host-project/network/public-dns.yaml|client-name-standard-public-dns|
|SC-7|./client-folder/standard/applications-infrastructure/host-project/network/vpc.yaml|host-project-id-global-standard-vpc|
|SC-7(5)|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-default-egress-deny-fwr|
|SC-7(5)|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-egress-allow-all-internal-fwr|
|SC-7(5)|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/firewall.yaml|host-project-id-standard-egress-allow-psc-fwr|
|SC-7(5)|./client-folder/standard/applications-infrastructure/host-project/network/vpc.yaml|host-project-id-global-standard-vpc|
|SC-7(C)|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-default-egress-deny-fwr|
|SC-7(C)|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-egress-allow-all-internal-fwr|
|SC-7(C)|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/firewall.yaml|host-project-id-standard-egress-allow-psc-fwr|

<!-- END OF SECURITY CONTROLS LIST -->
./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-default-egress-deny-fwr|
|SC-7(5)|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-egress-allow-all-internal-fwr|
|SC-7(5)|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/firewall.yaml|host-project-id-standard-egress-allow-psc-fwr|
|SC-7(5)|./client-folder/standard/applications-infrastructure/host-project/network/vpc.yaml|host-project-id-global-standard-vpc|
|SC-7(C)|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-default-egress-deny-fwr|
|SC-7(C)|./client-folder/standard/applications-infrastructure/host-project/network/firewall.yaml|host-project-id-standard-egress-allow-all-internal-fwr|
|SC-7(C)|./client-folder/standard/applications-infrastructure/host-project/network/psc/google-apis/firewall.yaml|host-project-id-standard-egress-allow-psc-fwr|

<!-- END OF SECURITY CONTROLS LIST -->
