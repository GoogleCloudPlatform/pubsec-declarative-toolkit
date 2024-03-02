# Testing IPSec throughput over FortiGate in GCP

This template deploys a simple architecture to test throughput of IPSec tunnel between 2 sites.

## How to use

1. Configure your test case using variables in `terraform.tfvars` (see below for more info)
2. Log in to gcloud tool to authenticate terraform provider
3. Save Google Cloud project name to GOOGLE_PROJECT environmetn variable
4. If using FortiFlex licensing export FORTIFLEX_ACCESS_USERNAME and FORTIFLEX_ACCESS_PASSWORD environment variables to access Flex API
5. Deploy environment using `terraform init && terraform apply`
6. Run default tests in `./tests_run.sh`
7. Destroy environment if not needed anymore `terraform destroy`

## Configuration

Several variables can be used to modify the deployment:

- **prefix** - configure your prefix for all deployed resources, so it's easier to identify them
- **firmware** - which version of FortiGate firmware do you want to deploy for tests
- **machine_type** - choose the Google Cloud machine type to be used for tested FortiGate (defaults to n2-standard-8)
- **flex_serials** - provide 2 existing and available serial numbers in FortiFlex. Terraform will generate tokens and apply them to test FortiGates
- **region_dut** - region where to deploy tested FortiGate
- **region_cli** - region where to deploy client-side FortiGate
- **phase2_enc** - encryption type to use for IPSec phase 2 (defaults to aes128gcm)
- **tunnel_count** - how many concurrent tunnels should be created. Each tunnel is built using a separate pair of public IP addresses. Multiple tunnels help utilize all CPUs. Tunnels will be aggregated using IPSec aggregation

Optimization options:
 - **opt_queues** - assigns only a single queue to management interface leaving more queues for data traffic interfaces
 - **opt_affinity** - attempts to manually fine-tune CPU affinity. This was necessary in some older firmware versions
 - **opt_ipsec-soft-dec-async** - enable *ipsec-soft-dec-async* setting (deprecated in 7.4.2)

 ## Custom testing

 Connect to *${var.prefix}-iperf-cli* instance and run tests against server at *172.20.1.100* address. Server runs the following:

 - http server with 64kB and 1MB files at /64k and /1M paths
 - iperf3 server
 - iperf server

 Client has ab, wrk, iperf3, iperf tools installed.


## Licensing

The published version expects to use FortiFlex licensing using existing licenses for 2 FortiGates. In order to use it you need to configure fortiflexvm provider by providing credentials in environment variables. If you prefer to use PAYG licensing, you need to do the following:
1. comment out the *module "flex"* block in main.tf file (around line 94)
2. remove lines refering to module.flex in fgt_left.tf (line 87) and fgt_right.tf (line 104)