<!-- BEGIN_AUTOMATED_INFRACOST_BLOCK -->
[![Generic badge](https://img.shields.io/badge/MonthlyCost-€68-purple.svg)](https://shields.io/)
<!-- END_AUTOMATED_INFRACOST_BLOCK -->
# Single Virtual Machine with two additional data disks creation example

Configuration in this directory creates a single Virtual Machine with additional data disks.
The first disk has a capacity of `5 GB`, and the second disk has a capacity of `10 GB`. Both disks are of the `Standard_LRS` type.

# Usage

To run this example you need to execute:

```bash
$ az login
$ az account set -s SUBSCRIPTION_ID # To be updated
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_virtual_machine"></a> [virtual\_machine](#module\_virtual\_machine) | ../../modules/virtual_machine | n/a |
## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_virtual_machine_outputs"></a> [virtual\_machine\_outputs](#output\_virtual\_machine\_outputs) | Virtual machine outputs. |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->