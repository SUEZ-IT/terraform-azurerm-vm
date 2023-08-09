# SUEZ Terraform availability_set submodule
## Introduction
The following README.md provides comprehensive guidance on using a Terraform module for deploying **Availability Set**.  

The module is designed to streamline the process of setting up and managing Availability Set on the Azure platform. It covers essential **requirements, usage instructions, inputs, outputs, and supported resources**.  

The README offers clear explanations of each input parameter and its constraints, along with illustrative examples to facilitate smooth implementation.  
<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.50.0 |
## Usage
Basic usage of this submodule is as follows:
```hcl
module "example" {
	source  = "<submodule-path>"

	# Required variables
	cloudbundle_info  = 
	index  = 
}
```
## Resources

| Name | Type |
|------|------|
| [azurerm_availability_set.avset](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudbundle_info"></a> [cloudbundle\_info](#input\_cloudbundle\_info) | **Cloud Bundle target datasource.**<br>  - Example:<pre>data "azurerm_resource_group" "main" {<br>    name = "rg-RG_NAME-dev"<br>  }<br><br>  module "availability_set" {<br>    ...<br>    cloudbundle_info = data.azurerm_resource_group.main<br>  }</pre> | `any` | n/a | yes |
| <a name="input_index"></a> [index](#input\_index) | **Availability Set index (used to determine the Availability Set name).**<br>  - Constraint:<br>  Valid values for index are between [001..999]<br>  - Example:<pre>index = 001</pre> | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Availability set ID. |
| <a name="output_name"></a> [name](#output\_name) | Availability set name. |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
