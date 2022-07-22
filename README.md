<!-- BEGIN_TF_DOCS -->
# SUEZ VMAAS TERRAFORM MODULE



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.82.0, < 3.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.client_credentials_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.client_credentials_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_log_analytics_datasource_windows_event.collect_apps](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_datasource_windows_event) | resource |
| [azurerm_log_analytics_datasource_windows_event.collect_system](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_datasource_windows_event) | resource |
| [azurerm_network_interface.VmNic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_extension.vmagent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| random_password.client_password | resource |
| random_string.client_login | resource |
| [azurerm_key_vault.cloudbundle_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_log_analytics_workspace.cloudbundle_la](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.rg_target](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_shared_image.osfactory_image](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/shared_image) | data source |
| [azurerm_subnet.vmsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability"></a> [availability](#input\_availability) | VM desired availability => 24/24 - 7/7, businessday, self-care, sleep | `string` | `"businessday"` | no |
| <a name="input_classification"></a> [classification](#input\_classification) | VM classification => application [app] or infrastructure [infra] | `string` | `"app"` | no |
| <a name="input_index"></a> [index](#input\_index) | Index of the VM | `number` | n/a | yes |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | VM OS disk type => Premium\_LRS, Standard\_LRS, StandardSSD\_LRS, StandardSSD\_ZRS, Premium\_ZRS | `string` | `"Standard_LRS"` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | VM OS type => Windows, Linux | `string` | n/a | yes |
| <a name="input_reboot_hebdo"></a> [reboot\_hebdo](#input\_reboot\_hebdo) | Allow downtime for maintenance and update | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Target resource group name | `string` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | VM role => frontend, backend, etc... | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | VM size (https://docs.microsoft.com/en-us/azure/virtual-machines/sizes). | `string` | n/a | yes |
| <a name="input_tags_cloudguard"></a> [tags\_cloudguard](#input\_tags\_cloudguard) | CloudGuard tags values | `map` | <pre>{<br>  "fusion_inventory": "TRUE"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kv_secret_login"></a> [kv\_secret\_login](#output\_kv\_secret\_login) | Login secret name inside your key vault |
| <a name="output_kv_secret_password"></a> [kv\_secret\_password](#output\_kv\_secret\_password) | Password secret name inside your key vault |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | Virtual Machine ID |
| <a name="output_virtual_machine_name"></a> [virtual\_machine\_name](#output\_virtual\_machine\_name) | Virtual machine name |
| <a name="output_virtual_machine_vnic_id"></a> [virtual\_machine\_vnic\_id](#output\_virtual\_machine\_vnic\_id) | Virtual network interface controller ID |
<!-- END_TF_DOCS -->