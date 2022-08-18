# Private Cloud SQL (PostgreSQL)

## Description
This service will create a private cloud SQL instance using a private service connection to your VPC. This allows all traffic to your cloud sql instance to remain on the VPC and not cross the internet.

## Prerequisites
This service assumes that you have a GCP project with a VPC network already setup. The VPC network must have "Google Private Access" enabled on it as well.

## Usage
This service requires modifiying 3 files:

### **fn-setters.yaml**
Update the following key:value pairs to match your environment

| Name | Description |
| --- | --- |
| project-id | The ID of the project that the cloud SQL instance will be created in |
| region | The region that the cloud SQL instance will be created in |
| network-name | The name of the VPC network to attache to |
| sql-db-name | The name to give to the new database that will be created |
| sql-user | The name of the sql user to create for the access to the database |
| sql-password-secret-name | The name of the secret to create that will store the sql users password |

### **fn-mutator.yaml**
Update the following key:value pairs to match your environment

| Name | Description |
| --- | --- |
| namespace | This should match the namespace in your KCC cluster that you want to create KRM resources in. The will default to config-control but if you created a namespace for your project of used the kcc-namespaces solution then update this to match |
| sqlInstanceName | The name you want to give the SQL Instance |

### **secret.yaml**
The SQL password to create as a K8's secret.

** **WARNING** ** - Remember to protect this file and be careful how you store it in your source repo as the password is only base64 encoded. It's not encrypted!

| Name | Description |
| --- | --- |
| password | The base64 encoded password of the SQL user |

### **Defaults**

You can easily change any of the defaults that this sevice uses by modifying the KRM manifest files.

| Name | Value | File(line number) |
| --- | --- | --- |
| SQL Version | POSTGRES_13 | sql.yaml(23) |
| Disk Size | 10GB | sql.yaml(29) |
| Instance Tier |  db-custom-2-7680 | sql.yaml(35) |
| Charset / Collation | UTF8 / en_US.UTF8 | sql.yaml(46/47) |

### **Fetch the package**
`kpt pkg get https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox.git/services/private-sql@main private-sql`
Details: https://kpt.dev/reference/cli/pkg/get/

### **View package content**
`kpt pkg tree private-sql`

Details: https://kpt.dev/reference/cli/pkg/tree/

### **Update and render package**
Remember to update the files noted above before running this command
`kpt fn render private-sql`

Details: https://kpt.dev/book/03-packages/04-rendering-a-package

### **Apply the package**
```
kpt live init private-sql
kpt live apply private-sql --reconcile-timeout=5m --output=table
```
Details: https://kpt.dev/reference/cli/live/