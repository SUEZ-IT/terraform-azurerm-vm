<!-- BEGIN_TF_DOCS -->
# SUEZ VMAAS TERRAFORM MODULE



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.50.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_availability_set.availabilityset](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/availability_set) | resource |
| [azurerm_backup_protected_vm.vm_backup](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/backup_protected_vm) | resource |
| [azurerm_key_vault_secret.client_credentials_login](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.client_credentials_password](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.virtual_machine_data_disk](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/managed_disk) | resource |
| [azurerm_monitor_data_collection_rule_association.datacr](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_network_interface.VmNic](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/network_interface) | resource |
| [azurerm_storage_account.vm_sa](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/storage_account) | resource |
| [azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.dependencyagent](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.vm_lin_post_deploy_script](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.vm_win_post_deploy_script](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.vmagent](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.vmagentama](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/resources/windows_virtual_machine) | resource |
| [null_resource.validation_availability_set](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.validation_create_availability_set](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.validation_wallix_ad](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.validation_wallix_ba](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| random_id.randomId | resource |
| random_password.client_password | resource |
| random_string.client_login | resource |
| random_string.random_string | resource |
| [archive_file.win_post_deploy_scripts_zipped](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [azurerm_availability_set.availability_set](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/availability_set) | data source |
| [azurerm_backup_policy_vm.policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/backup_policy_vm) | data source |
| [azurerm_key_vault.cloudbundle_kv](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/key_vault) | data source |
| [azurerm_log_analytics_workspace.cloudbundle_la](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_data_collection_rule.monitordatacolrule](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/monitor_data_collection_rule) | data source |
| [azurerm_recovery_services_vault.vault_backup](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/recovery_services_vault) | data source |
| [azurerm_resource_group.inframsp](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.rg_target](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/resource_group) | data source |
| [azurerm_shared_image.osfactory_image](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/shared_image) | data source |
| [azurerm_subnet.vmsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.50.0/docs/data-sources/subscription) | data source |
| [template_file.win_post_deploy_scripts_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_domain"></a> [ad\_domain](#input\_ad\_domain) | add vm on ad domain or workgroup | `string` | `""` | no |
| <a name="input_availability"></a> [availability](#input\_availability) | VM desired availability => 24/24 - 7/7, businessday, self-care, sleep | `string` | `"businessday"` | no |
| <a name="input_availability_set_name"></a> [availability\_set\_name](#input\_availability\_set\_name) | Set the existing Availabilty Set to attach it to the Virtual Machine. | `string` | `""` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | (Optional) Set the availability zone for the Virtual Machine. By default, value is empty, Azure chose the zone for the customer depending on available hardware. | `string` | `""` | no |
| <a name="input_backup"></a> [backup](#input\_backup) | (Optional) VM backup enable or not => true, false | `string` | `"false"` | no |
| <a name="input_cloudinit_parts"></a> [cloudinit\_parts](#input\_cloudinit\_parts) | (Optional) A list of maps that contain the information for each part in the cloud-init configuration.<br>Each map should have the following fields:<br>* content-type - type of content for this part, e.g. text/x-shellscript => https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config#content_type<br>* filepath - path to the file to use as a template<br>* vars - map of variables to use with the part template | <pre>list(object({<br>    content-type = string<br>    filepath     = string<br>    vars         = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_create_availability_set"></a> [create\_availability\_set](#input\_create\_availability\_set) | Create a new Availability Set and attach the Virtual Machine to it. | `bool` | `false` | no |
| <a name="input_data_disk"></a> [data\_disk](#input\_data\_disk) | (Optional) Map of data disk(s) | <pre>map(object({<br>    size = number<br>    type = string<br>    lun  = number<br>  }))</pre> | `{}` | no |
| <a name="input_deployed_by"></a> [deployed\_by](#input\_deployed\_by) | (Optional) VM information => VMaaS, Test\_by\_VMaaS | `string` | `"VMaaS"` | no |
| <a name="input_gallery_subscription_id"></a> [gallery\_subscription\_id](#input\_gallery\_subscription\_id) | (Optional) Azure compute gallery subscription ID | `string` | `"d980e79b-480a-4282-a6b5-27e052e79f4b"` | no |
| <a name="input_index"></a> [index](#input\_index) | Index of the VM | `number` | n/a | yes |
| <a name="input_os"></a> [os](#input\_os) | OS type and version | <pre>object({<br>    type    = string<br>    version = string<br>  })</pre> | n/a | yes |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | (Optional) VM OS disk type => Premium\_LRS, Standard\_LRS, StandardSSD\_LRS, StandardSSD\_ZRS, Premium\_ZRS | `string` | `"Standard_LRS"` | no |
| <a name="input_reboothebdo"></a> [reboothebdo](#input\_reboothebdo) | (Optional) Default reboot time is every Tuesday at 4AM (2.4). In order to update day and time, use this parameter. <br>  "VM reboot time => [1-5].[0-23], No"<br>  Find more details here : https://dev.azure.com/suez-it-foundations-cloud/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-# | `string` | `"2.4"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Target resource group name | `string` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | VM role => frontend, backend, etc... | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | VM size (https://docs.microsoft.com/en-us/azure/virtual-machines/sizes). | `string` | n/a | yes |
| <a name="input_start"></a> [start](#input\_start) | (Optional) Use this parameter only if availability = "businessday".<br>  "VM desired start => [1-5].[0-23],[1-5].[0-23],[1-5].[0-23],[1-5].[0-23], No"<br>  Example for VM that will be started at 7AM on Thursday and all others workdays at 5AM: <br>    availability = "businessday"<br>    start        = "1.5,2.5,3.5,4.7,5.5"<br>  Find more details here : https://dev.azure.com/suez-it-foundations-cloud/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-# | `string` | `""` | no |
| <a name="input_stop"></a> [stop](#input\_stop) | (Optional) Use this parameter only if availability = "businessday".<br>  "VM desired stop => [1-5].[0-23],[1-5].[0-23],[1-5].[0-23],[1-5].[0-23], No"<br>  Example for VM that will be stopped at 5PM on Thursday and all others workdays at 11PM: <br>    availability = "businessday"<br>    start        = "1.23,2.23,3.23,4.23,5.17"<br>  Find more details here : https://dev.azure.com/suez-it-foundations-cloud/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-# | `string` | `""` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | (Optional) By default, if the 'subnet' argument is not defined, the VM will be deployed directly in the main subnet of the Cloud Bundle. However, if the 'subnet' argument is specified, the VM will be deployed in the designated subnet. | `string` | `""` | no |
| <a name="input_tags_cloudguard"></a> [tags\_cloudguard](#input\_tags\_cloudguard) | (Optional) VM network flows => find more details here : https://dev.azure.com/suez-it-foundations-cloud/Cloud%20Documentation/_wiki/wikis/Cloud-Documentation.wiki/6066/From-OS-Shared-Image-Gallery?anchor=set-virtual-machine%27s-tags# | `map(any)` | <pre>{<br>  "fusion_inventory": "TRUE",<br>  "internet": "REGULAR"<br>}</pre> | no |
| <a name="input_wallix_ad_account"></a> [wallix\_ad\_account](#input\_wallix\_ad\_account) | This variable is mandatory when wallix\_client is true | `string` | `""` | no |
| <a name="input_wallix_ba_account"></a> [wallix\_ba\_account](#input\_wallix\_ba\_account) | This variable is mandatory when wallix\_client is true | `string` | `""` | no |
| <a name="input_wallix_client"></a> [wallix\_client](#input\_wallix\_client) | n/a | `bool` | `false` | no |
| <a name="input_windows_postinstall_script"></a> [windows\_postinstall\_script](#input\_windows\_postinstall\_script) | Path to a file that Terraform will copy on the VM and then execute, eg. to install a IIS server and set it up and running | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudbundle_type"></a> [cloudbundle\_type](#output\_cloudbundle\_type) | Cloudbundle type where your resources are located |
| <a name="output_created_availibility_set"></a> [created\_availibility\_set](#output\_created\_availibility\_set) | Created Availibity Set |
| <a name="output_existing_availibility_set"></a> [existing\_availibility\_set](#output\_existing\_availibility\_set) | Existing Availibilty Set |
| <a name="output_kv_secret_login"></a> [kv\_secret\_login](#output\_kv\_secret\_login) | Login secret name inside your key vault |
| <a name="output_kv_secret_password"></a> [kv\_secret\_password](#output\_kv\_secret\_password) | Password secret name inside your key vault |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Resource group name |
| <a name="output_subscription_name"></a> [subscription\_name](#output\_subscription\_name) | Current subscription name |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | Virtual Machine ID |
| <a name="output_virtual_machine_name"></a> [virtual\_machine\_name](#output\_virtual\_machine\_name) | Virtual machine name |
| <a name="output_virtual_machine_vnic_id"></a> [virtual\_machine\_vnic\_id](#output\_virtual\_machine\_vnic\_id) | Virtual network interface controller ID |
<!-- END_TF_DOCS -->