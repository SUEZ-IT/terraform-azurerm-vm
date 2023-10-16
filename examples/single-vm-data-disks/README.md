<!-- BEGIN_AUTOMATED_INFRACOST_BLOCK -->
[![Generic badge](https://img.shields.io/badge/MonthlyCost-€63-purple.svg)](https://azure.microsoft.com/en-us/pricing/calculator/)
<!-- END_AUTOMATED_INFRACOST_BLOCK -->
# Single Virtual Machine with two additional data disks creation example

Configuration in this directory creates a single Virtual Machine with additional data disks:

| Resource Type| Number | OS Type | Index | Size | OS Disk Type | Role | AD Domain
|--|--|--|--|--|--|--|--|
| Virtual Machine | 1 | Ubuntu 22.04 | 123 | Standard_D2s_v3 | Standard_LRS | example | DomainName |

| Resource Type| Number | Disk Size | Disk Type |
|--|--|--|--|
| Data Disks | 2 | [5, 10] | Standard_LRS |

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->

# Usage

Access the example file `main.tf` by clicking on the Source Code link located slightly above.

To run this example you need to execute:

```bash
$ az login
$ az account set -s SUBSCRIPTION_ID # To be updated
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don't need these resources.
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
| [azurerm_resource_group.cloud_bundle_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscriptions.osfactory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_virtual_machine_outputs"></a> [virtual\_machine\_outputs](#output\_virtual\_machine\_outputs) | Virtual machine outputs. |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->