# Example: API token

This example will create on FortiGates an API user account and will assign it a 'prof_admin' role and a random token generated during terraform deployment. The token will be stored in GCP Secret Manager and in module outputs. Access will be restricted to 10.0.0.0/24 subnet.

Note: token will be visible to anyone having access to terraform state file, it is also included in VM instance metadata.
