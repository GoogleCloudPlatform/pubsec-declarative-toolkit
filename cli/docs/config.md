# Arete Configuration #

The arete CLI uses a local configuration file to override certain settings.

The config file is named `config.yaml` and is stored locally to the CLI itself. When the CLI is
first run it will create the cache directory (defaults to users home folder) called `.arete`

It's a YAML formated file and contains the following configurable settings:

| Setting        | Description | Default |
| --- | --- | --- |
| cache | This is the location of local cache directory where items like the config file, solutions file and otheres are stored. | ~/.arete |
| git_token| If the GitHub repository that you are adding is private then you can still access the raw solutions file using a secure token. |
| network | When creating a new config controller cluster you can override the VPC network that will be created | |
| network.name   | The name of the VPC |  kcc-controller |
| network.subnet | The name of the subnet | kcc-regional-subnet |
| network.cidr   | The CIDR of the subnet | 192.168.0.0/16 |
| verbose        | If the verbose flag is passed in then this gets set | false |
