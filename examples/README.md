# How to use theses examples

## Example selection
Change directory to the example of your choice:
```bash
cd examples/single-linux-vm
```

## Log in to Azure using Azure CLI
AZ login (choose the right subscription):
```bash
az login
az account set -s "XXXX-XXXX-XXXX-XXXX" # To be updated
```

## Resource group target name
Replace the `resource_group_name` variable value in the `example.auto.tfvars` to match the Resource Group target name:  
`./example.auto.tfvars`  
from:
```hcl
resource_group_name = "rg-example-dev"
```
to:
```hcl
resource_group_name = "RESOURCE_GROUP_NAME"
```

## Terraform deployment
```bash
terraform init
terraform [plan | apply | destroy ]
```