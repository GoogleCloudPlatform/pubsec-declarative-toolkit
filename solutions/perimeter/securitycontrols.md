AC-2 - (A) Address which types of accounts are in use (local, AAD, etc.). Point to ops doc to cover off B-K

AC-2(2) - Address how "break glass" accounts are resealed (effectively "disabled" as no one knows the password)

AC-2(3) - Setting for how inactive local accounts are automatically disabled, or statement that there are no local accounts other than break-glass

AC-2(4) - Setting so audit records are created for account operations. Reference ops procedure on how managers are notified

AC-3(7) - Settings for roles and privs assigned

AC-4 - Settings for firewall flows and default deny

AC-5 - Settings for roles and what org roles correspond to Fortigate roles

AC-6 - Address how least privilege is accomplished by roles

AC-6(10) - Statement that FortiGate has been assessed against allowing non-priv users to execute priv functions (ask Aaron a good reference to some accreditation Fortigate has)

AC-7 - Settings for account failed login limits

AC-8, AC-9, including subs 1-4,  - Setting for login notification, etc.

AC-10 - Settings for concurrent sessions

AC-11 (inc sub) - Settings for inactive sessions

AC-12 - Settings for session termination

AC-16(4), AC-16(5) - If any type of security tagging is done (i.e. GCP tagging) then this needs a blurb on how these are used/implemented in FortiGate (i.e. firewall rules based on GCP tags, etc.

AC-17(1), AC-17(3), AC-17(100) - Statement on access to Fortigate management only from internal system (if that's true)

AC-17(2) - Settings for TLS and cipher strength of console UI

AU-2, AU-3, AU-3(1) - Statement on what is being audited and the strategy, settings on what auditing is enabled

AU-4, AU-4(1) - Statement on audit retention and settings

AU-5, AU-5(1) - Statement on audit failure actions and settings

AU-7 (inc subs) - Statement on what audit report generation is available (this should be available somewhere else as its a product feature thing)

AU-8 (inc subs) - Statement on audit records showing in format convertible to GMT

AU-8(1) - Setting showing sync to authoritative time (Google cloud time?)

AU-9 (inc subs) - Statement on how the audit information is protected (i.e. role to access, sent to centralized logging which is immutable, etc) and supporting settings

AU-11 - Settings showing audit retention on device, reference to ops procedure on centralized logging

AU-12 - Settings showing audit logging settings, roles which have access

AU-12(1) - Statement that logging is forwarded to a central location

AU-12(2) - Statement on what format is used for logging (CEF)

CM-2, CM-2(2), CM-2(3)  - Statement on how the FortiGate configuration is controlled (i.e. GitHub repo + Terraform/Ansible)

CM-2(1) - Statement on how the FortiGate is being updated

CM-7(2) - Statement on how the FortiGate is a hardened, locked appliance (this would be available somewhere else as its a product feature thing)

IA-2 - Settings and statement on user authentication (local, AAD, etc)

IA-2(1-3) - Settings and statement on MFA (i.e. via AAD, none (?) for local users)

IA-2(6, 8, 9, 11) - Point back to AAD supporting documentation for MFA device support

IA-2(8,9) - Settings and statement that everything is over TLS which is replay resistant

IA-2(10) - Statement that single sign-on is not supported, explicit sign-on must be made to the FortiGate

IA-3 - Settings and statement that the FortiGate can only be accessed from specific jump servers only (?)

IA-3(1) - Setting and statement that everything is over TLS

IA-5(1) - Settings for password policies for local accounts, point back to AAD supporting documentation

IA-6 - Statement on how the FortiGate authentication failures are displayed (this would be available somewhere else as its a product feature thing)

IA-7 - Settings and statement on ciphers supported

IA-8 - Statement that only org users exist

MA-4(6) - Setting and statement that everything is over TLS

SC-5(1-2) - Settings and statements on any DoS prevention, capacity management capabilities enabled

SC-7, SC-7(5, 9, 11) - Settings and statements on flow rules in place

SC-7(18) - Statement on how the FortiGate fails closed (this would be available somewhere else as its a product feature thing)

SC-8 (inc sub) - Setting and statement that everything is over TLS

SC-10 - Settings and statement on session timeout

SC-13 - Settings and statement on ciphers supported

SC-18(1,3,4) - Statement on how the FortiGate is a hardened, locked appliance (this would be available somewhere else as its a product feature thing)

SC-23 - Setting and statement that everything is over TLS

SC-23(1, 3) - Statement on how the FortiGate creates and closes a session (this would be available somewhere else as its a product feature thing)

SC-24 - Statement on how the FortiGate fails closed (this would be available somewhere else as its a product feature thing)

SC-39 - Statement on how the FortiGate is a hardened, locked appliance and has been assessed for proper isolation (this would be available somewhere else as its a product feature thing)

SI-3(2,4, 7) - Settings and statements on updating for any malicious code update protections that are turned on

SI-4(4,5,7) - Settings and statements on inbound/outbound monitoring, statement on alerting (i.e. done by something else)

SI-6, SI-7(1), SI-11, SI-16 - Statement on how the FortiGate is a hardened, locked appliance and has been assessed for proper detection of tampering, error handling (this would be available somewhere else as its a product feature thing)