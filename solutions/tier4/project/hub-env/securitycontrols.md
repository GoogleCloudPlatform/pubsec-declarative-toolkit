# Organization Controls - P1

## AC-2 - (A) ACCOUNT MANAGEMENT

The organization identifies and selects the following types of information system accounts to support organizational missions/business functions

Address which types of accounts are in use

* Fortigates VM
  * One GCP service account is created and attached to both Fortigates VM.
  * The Fortigates/FortiOS comes with a default local `admin` account.
  * Federated accounts from Google Cloud Identities are used to allow access to Fortigates serial console.

* Management VM
  * One GCP service account is created and attached to the `management` VM.
  * Federated accounts from Google Cloud Identities are used to allow access to the management VM.

## Technical Controls - P1

### AC-3(7) - ACCESS ENFORCEMENT | ROLE-BASED ACCESS CONTROL

The information system enforces a role-based access control policy over defined subjects and objects and controls access based upon organization-defined roles and users authorized to assume such roles.

Role policies for accounts are being set in this package

* Settings for roles and privs assigned (only for GCP custom role allowing access to SDN)

* Settings for roles and what org roles correspond to FortiGate roles

### AC-17(1), REMOTE ACCESS | AUTOMATED MONITORING / CONTROL

The information system monitors and controls remote access methods.

* Users are forced to use IAP Desktop to access (via RDP) the management VM before having SSH or HTTPS access to the Fortigate appliances.

* Serial console is accessible from the GCP console (console.cloud.google.com) and requires a specific set of IAM permissions.

* GCP Audit logs are generated when resources are connected with IAP.

* Fortigates logs are generated when users are logging in.

### AC-17(3), REMOTE ACCESS | MANAGED ACCESS CONTROL POINTS

The information system routes all remote accesses through [Assignment: organization-defined number] managed network access control points.

* Users are forced to use IAP Desktop to access (via RDP) the management VM before having SSH or HTTPS access to the Fortigate appliances.

* Serial console is accessible from the gcp console (console.cloud.google.com) and requires a specific set of IAM permissions.

### AC-17(100) - Remote access to privileged accounts is performed on dedicated management consoles governed entirely by the system’s security policies and used exclusively for this purpose (e.g. Internet access not allowed)

* Access to manage the Fortigates can only take place from the management VM. They are both connected through an internal management network with no access to the internet.
