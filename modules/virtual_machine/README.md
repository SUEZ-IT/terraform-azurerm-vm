# SUEZ Terraform virtual_machine submodule
## Introduction
The following README.md provides comprehensive guidance on using a Terraform module for deploying **Virtual Machines**. The module is designed to streamline the process of setting up and managing Virtual Machines on the Azure platform. It covers essential **requirements, usage instructions, inputs, outputs, and supported resources**.  

By utilizing the module, users can efficiently configure various aspects of Virtual Machines, such as **availability, operating system, role, size, and more**.  

The README offers clear explanations of each input parameter and its constraints, along with illustrative examples to facilitate smooth implementation.  

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.4.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.50.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1.3 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |
## Usage
Basic usage of this submodule is as follows:
```hcl
module "example" {
	source  = "SUEZ-IT/vm/azurerm//modules/<submodule-path>" # To be updated
	version  = "X.X.X" # To be updated

	# Required Provider configuration (only for virtual_machine submodule)
	providers = {
	  azurerm.gallery = azurerm.gallery
	}

	# Required variables
	ad_domain  = 
	cloudbundle_info  = 
	index  = 
	os  = 
	role  = 
	size  = 

	# Optional variables
	availability = "businessday"
	availability_set_id = null
	availability_zone = ""
	backup = "false"
	bastion_allowed_ad_entities = ""
	bastion_allowed_ad_groups = ""
	bastion_allowed_ba_entities = ""
	cloudinit_parts = []
	data_disk = {}
	deployed_by = "VMaaS"
	is_accessible_from_bastion = false
	os_disk_type = "Standard_LRS"
	playbook_list = ""
	start = ""
	start_sequence = null
	stop = ""
	stop_sequence = null
	subnet = ""
	create_default_keyvault = true
	keyvault_name = ""
	tags = null
	tags_cloudguard = {
  "fusion_inventory": "TRUE",
  "internet": "REGULAR"
}
	weekly_reboot = "2.4"
	windows_postinstall_script = ""
}
```
## Resources

| Name | Type |
|------|------|
| [azapi_update_resource.vm_update](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/update_resource) | resource |
| [azurerm_backup_protected_vm.backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) | resource |
| [azurerm_key_vault.default_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.client_credentials_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.client_credentials_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_maintenance_assignment_virtual_machine.vm_maintenance_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/maintenance_assignment_virtual_machine) | resource |
| [azurerm_maintenance_configuration.vm_maintenance_configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/maintenance_configuration) | resource |
| [azurerm_managed_disk.virtual_machine_data_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_monitor_data_collection_rule_association.datacr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.aad_ssh_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.agentama](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.dependencyagent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.vm_win_post_deploy_script](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| null_resource.validation_bastion_ad | resource |
| null_resource.validation_bastion_ba | resource |
| random_password.client_password | resource |
| random_string.client_login | resource |
| archive_file.win_post_deploy_scripts_zipped | data source |
| [azurerm_backup_policy_vm.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/backup_policy_vm) | data source |
| [azurerm_key_vault.cloudbundle_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_log_analytics_workspace.cloudbundle_la](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_data_collection_rule.monitordatacolrule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_data_collection_rule) | data source |
| [azurerm_recovery_services_vault.vault_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/recovery_services_vault) | data source |
| [azurerm_resource_group.inframsp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_shared_image.osfactory_image](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/shared_image) | data source |
| [azurerm_subnet.vmsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| template_file.win_post_deploy_scripts_template | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_domain"></a> [ad\_domain](#input\_ad\_domain) | **Virtual Machine target Active Directory domain name or workgroup.**<br>  - Constraint:<br>  Valid values for ad\_domain are [DomainName \| workgroup]<br>  - Example:<pre>ad_domain = "mydomain.local"</pre> | `string` | n/a | yes |
| <a name="input_availability"></a> [availability](#input\_availability) | **Virtual Machine desired availability.**<br>  - Constraint:<br>  Valid values for availability are ["24/24 - 7/7" \| "businessday" \| "self-care" \| "sleep" ]<br>  - Example:<pre>availability = "businessday"</pre> | `string` | `"businessday"` | no |
| <a name="input_availability_set_id"></a> [availability\_set\_id](#input\_availability\_set\_id) | **Availability Set ID to attach the Virtual Machine to.**<br>  - Example:<pre>module "availability_set" {<br>  ...<br>}<br><br>module "virtual_machine" {<br>  ...<br>  availability_set_id = module.availability_set.id<br>}</pre> | `string` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | **Set the Availability Zone for the Virtual Machine.**<br>  *By default, Azure chose the zone for the customer depending on available hardware.*<br>  - Constraint:<br>  Valid values for availability\_zone are ["1" \| "2" \| "3"]<br>  - Example:<pre>availability_zone = "1"</pre> | `string` | `""` | no |
| <a name="input_backup"></a> [backup](#input\_backup) | **Enabling Virtual Machine backup.**<br>  - Constraint:<br>  Valid values for backup are ["true" \| "false"]<br>  - Example:<pre>backup = "true"</pre> | `string` | `""` | no |
| <a name="input_create_default_keyvault"></a> [create\_default\_keyvault](#input\_create\_default\_keyvault) | **Whether or not a key vault should be created before deploying the virtual machine.**<br>  - Constraint:<br> Valid values for create_default_keyvault are [true | false] <br> If `create_default_keyvault = false`, `keyvault_name` value must be provided to the module.<br>  - Example:<pre>create_default_keyvault = true</pre> | `bool` | `true` | no 
| <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name) | **Name of an existing Azure Key Vault in which the virtual machines credentials should be stored.**<br>  - Constraint:<br> Required when create_default_keyvault is false .<br>  - Example:<pre>keyvault_name = "mycustomkv"</pre> | `string` | `""` | no |
| <a name="input_bastion_allowed_ad_entities"></a> [bastion\_allowed\_ad\_entities](#input\_bastion\_allowed\_ad\_entities) | **Active Directory Application account(s) list that will be used by bastion to access the Virtual Machine.**<br>  - Constraint:<br>  ad\_domain != "workgroup"<br>  Provide a list of valid Active Directory Application account(s) that will access the Virtual Machine.<br>  - Example:<pre>bastion_allowed_ad_entities = "ADAccount1,ADAccount1"</pre> | `string` | `""` | no |
| <a name="input_bastion_allowed_ad_groups"></a> [bastion\_allowed\_ad\_groups](#input\_bastion\_allowed\_ad\_groups) | **Active Directory Application group(s) list that will be used by bastion to access the Virtual Machine.**<br>  - Constraint:<br>  ad\_domain != "workgroup"<br>  Provide a list of valid Active Directory Application group(s) that will access the Virtual Machine.<br>  - Example:<pre>bastion_allowed_ad_groups = "ADGroup1,ADGroup1"</pre> | `string` | `""` | no |
| <a name="input_bastion_allowed_ba_entities"></a> [bastion\_allowed\_ba\_entities](#input\_bastion\_allowed\_ba\_entities) | **Bastion account(s) list that will be used to access bastion.**<br>  Provide a list of valid bastion account(s).<br>  - Example:<pre>bastion_allowed_ba_entities = "BastionAccount1,BastionAccount2"</pre> | `string` | `""` | no |
| <a name="input_cloudbundle_info"></a> [cloudbundle\_info](#input\_cloudbundle\_info) | **Cloud Bundle target datasource.**<br>  - Example:<pre>data "azurerm_resource_group" "main" {<br>  name = "rg-RG_NAME-dev"<br>}<br><br>module "virtual_machine" {<br>  ...<br>  cloudbundle_info = data.azurerm_resource_group.main<br>}</pre> | `any` | n/a | yes |
| <a name="input_cloudinit_parts"></a> [cloudinit\_parts](#input\_cloudinit\_parts) | **Virtual Machine cloud-init configuration for Linux Operating System.**<br>  A list of maps that contain the information for each part in the cloud-init configuration.<br>  Each map should have the following fields:<br>  `content-type` - type of content for this part, e.g. `text/x-shellscript` => https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config#content_type<br>  `filepath` - path to the file to use as a template<br>  `vars` - map of variables to use with the part template<br>  - Constraint:<br>  Valid values must be configured for `content-type`, `filepath`, `vars` (see the link above).<br>  - Example:<pre>cloudinit_parts = [<br>  {<br>      filepath = "./startup-script.sh"<br>      content-type = "text/x-shellscript"<br>      vars = {<br>        var_name = "var_value"<br>      }<br>  }<br>]</pre> | <pre>list(object({<br>    content-type = string<br>    filepath     = string<br>    vars         = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_data_disk"></a> [data\_disk](#input\_data\_disk) | **Virtual Machine data disk(s).**<br>  - Example:<pre>data_disk = {<br>  "1" = {<br>    lun = 1<br>    type = "Standard_LRS"<br>    size = 5<br>  }<br>}</pre> | <pre>map(object({<br>    size = number<br>    type = string<br>    lun  = number<br>  }))</pre> | `{}` | no |
| <a name="input_deployed_by"></a> [deployed\_by](#input\_deployed\_by) | **Virtual Machine information, do not modify.**<br>  - Constraint:<br>  Valid values for deployed\_by are ["VMaaS" \| "Test\_by\_VMaaS"]<br>  - Example:<pre>deployed_by = "VMaaS"</pre> | `string` | `"VMaaS"` | no |
| <a name="input_index"></a> [index](#input\_index) | **Virtual Machine index (used to determine the Virtual Machine name).**<br>  - Constraint:<br>  Valid values for index are between [001..999]<br>  - Example:<pre>index = 001</pre> | `number` | n/a | yes |
| <a name="input_is_accessible_from_bastion"></a> [is\_accessible\_from\_bastion](#input\_is\_accessible\_from\_bastion) | **Add the Virtual Machine to the bastion.**<br>  - Constraint:<br>  Valid values for is\_accessible\_from\_bastion are [true \| false]<br>  If `is_accessible_from_bastion = true`, `bastion_allowed_ba_entities` value must be provided to the module.<br>  If `is_accessible_from_bastion = true` and ad\_domain != "workgroup" and os.type = "Windows", `bastion_allowed_ad_entities` or `bastion_allowed_ad_groups` value must be provided to the module.<br>  - Example:<pre>ad_domain = "DomainName"<br>is_accessible_from_bastion = true<br>bastion_allowed_ba_entities = "BastionAccount1,BastionAccount2"<br>bastion_allowed_ad_entities = "ADAccount1,ADAccount1"</pre> | `bool` | `false` | no |
| <a name="input_os"></a> [os](#input\_os) | **Virtual Machine Operating System type and version.**<br>  - Constraint:<br>  Valid values for os are [{ type = "Ubuntu", version = "2204" } \| { type = "Windows", version = "2019" } \| { type = "Windows", version = "2022" } \| { type = "Rocky", version = "8" } \| { type = "Rocky", version = "9" } \| { type = "Redhat", version = "9" }]<br>  - Example:<pre>os = {<br>  type = "Windows"<br>  version = "2022"<br>}</pre> | <pre>object({<br>    type    = string<br>    version = string<br>  })</pre> | n/a | yes |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | **Virtual Machine Operating System disk type.**<br>  - Constraint:<br>  Valid values for os\_disk\_type are ["Premium\_LRS" \| "Standard\_LRS" \| "StandardSSD\_LRS" \| "StandardSSD\_ZRS" \| "Premium\_ZRS"]<br>  - Example:<pre>os_disk_type = "Standard_LRS"</pre> | `string` | `"Standard_LRS"` | no |
| <a name="input_playbook_list"></a> [playbook\_list](#input\_playbook\_list) | **Playbook(s) from the OS Automation Tower marketplace to apply to the Virtual Machine after deployment.**<br>  - Constraint:<br>  The specified playbook name(s) must exist in the OS Automation Tower marketplace.<br>  - Example:<pre>playbook_list = "playbook1,playbook2"</pre> | `string` | `""` | no |
| <a name="input_role"></a> [role](#input\_role) | **Virtual Machine role.**<br>  - Example:<pre>role = "webserver"</pre> | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | **Virtual Machine size (https://docs.microsoft.com/en-us/azure/virtual-machines/sizes).**<br>  - Constraint:<br>  Valid values for size must be avavailable in the Cloud Bundle target region.<pre># List all Virtual Machine sizes available in northeurope<br>  az vm list-sizes --location "northeurope" --query "[].name"</pre><pre># Search for a specific size in northeurope<br>  az vm list-sizes --location "northeurope" --query "[?name=='Standard_DC8_v2']"</pre>- Example:<pre>size = "Standard_D2s_v3"</pre> | `string` | n/a | yes |
| <a name="input_start"></a> [start](#input\_start) | **Virtual Machine desired start.**<br>  *Find more details here : WIKI/Cloud%20Documentation/\_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#*<br>  - Constraint:<br>  Valid values for start are ["1.[0..23]","2.[0..23]","3.[0..23],"4.[0..23]","5.[0..23]" \| "No"]<br>  This parameter must be used only if<pre>availability = "businessday"</pre>- Example:<pre>availability = "businessday"<br># Start Virtual Machine every weekday at 7AM<br>start        = "1.7,2.7,3.7,4.7,5.7"</pre> | `string` | `""` | no |
| <a name="input_start_sequence"></a> [start\_sequence](#input\_start\_sequence) | **Virtual Machine start scheduling sequence.**<br>  *Default start sequence is null. No start sequence will be applied unless you specifically choose one*<br>  *Find more details here : WIKI/Cloud%20Documentation/\_wiki/wikis/Cloud-Documentation.wiki/6263/How-to-automate-VM-Start-Stop-Reboot-?anchor=advance*<br>  - Constraint:<br>  Valid values for start\_sequence are "[1..n]", with n > 0<br>  - Example:<pre># Start the current Virtual Machine first<br>start_sequence = 1</pre> | `number` | `null` | no |
| <a name="input_stop"></a> [stop](#input\_stop) | **Virtual Machine desired stop.**<br>  *Find more details here : WIKI/Cloud%20Documentation/\_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#*<br>  - Constraint:<br>  Valid values for stop are ["1.[0..23]","2.[0..23]","3.[0..23],"4.[0..23]","5.[0..23]" \| "No"]<br>  This parameter must be used only if<pre>availability = "businessday"</pre>- Example:<pre>availability = "businessday"<br># Stop Virtual Machine every weekday at 7PM<br>stop        = "1.19,2.19,3.19,4.19,5.19"</pre> | `string` | `""` | no |
| <a name="input_stop_sequence"></a> [stop\_sequence](#input\_stop\_sequence) | **Virtual Machine shutdown scheduling sequence.**<br>    *Default shutdown sequence is null. No shutdown sequence will be applied unless you specifically choose one*<br>    *Find more details here : WIKI/Cloud%20Documentation/\_wiki/wikis/Cloud-Documentation.wiki/6263/How-to-automate-VM-Start-Stop-Reboot-?anchor=advance*<br>    - Constraint:<br>    Valid values for stop\_sequence are "[1..n]", with n > 0<br>    - Example:<pre># Stop the current Virtual Machine first<br>  stop_sequence = 1</pre> | `number` | `null` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | **By default, if the 'subnet' argument is not defined, the Virtual Machine will be deployed directly in the main subnet of the Cloud Bundle. However, if the 'subnet' argument is specified, the Virtual Machine will be deployed in the designated subnet.**<br>  - Example:<pre>subnet = "snet-testvnet-test2-dev"</pre> | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | **Virtual Machine user-defined tags.**<br>    *Default value for this variable is null.*<br>    *Find more details here : WIKI/Cloud%20Documentation/\_wiki/wikis/Cloud-Documentation.wiki/7086/How-to-add-custom-tags-to-a-Virtual-Machine*<br><br>    - Constraint:<br>      You can apply up to 50 tags to a resource in Azure. <br>      Make sure that the number of tags does not exceed 50 when adding custom tags.<br>      To access further information, please refer to https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits<br><br>    - Example:<pre>tags = {<br>    key1 = "value1"<br>    key2 = "value2"<br>    key3 = "value3"<br>  }</pre> | `map(string)` | `null` | no |
| <a name="input_tags_cloudguard"></a> [tags\_cloudguard](#input\_tags\_cloudguard) | **Open network flows for the Virtual Machine**<br>  *Find more details here: WIKI/Cloud%20Documentation/\_wiki/wikis/Cloud-Documentation.wiki/6066/From-OS-Shared-Image-Gallery?anchor=set-virtual-machine%27s-tags#*<br>  - Constraint:<br>  Valid values for tags\_cloudguard are <br>  [{<br>    "fusion\_inventory" = ["TRUE" \| "FALSE"]<br>    "internet"         = ["REGULAR" \| "LARGE"]<br>  }]<br>  - Example:<pre>tags_cloudguard = {<br>  "fusion_inventory" = "TRUE"<br>  "internet"         = "REGULAR"<br>}</pre> | `map(any)` | <pre>{<br>  "fusion_inventory": "TRUE",<br>  "internet": "REGULAR"<br>}</pre> | no |
| <a name="input_weekly_reboot"></a> [weekly\_reboot](#input\_weekly\_reboot) | **Virtual Machine weekly reboot.**<br>  *Default reboot time is every Tuesday at 4AM (2.4).*<br>  *Find more details here : WIKI/Cloud%20Documentation/\_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#*<br>  - Constraint:<br>  Valid values for weekly\_reboot are "[1..5].[0..23]"<br>  - Example:<pre># Reboot every wednesday at 3AM<br>weekly_reboot = "3.3"</pre> | `string` | `"2.4"` | no |
| <a name="input_windows_postinstall_script"></a> [windows\_postinstall\_script](#input\_windows\_postinstall\_script) | **Virtual Machine post-configuration script for Windows Operating System.**<br>  *Provide a path to a PowerShell script that Terraform will copy on the Virtual Machine and then execute.*<br>  - Constraint:<br>  os.type = "Windows"<br>  - Example:<pre>windows_postinstall_script = "./startup-script.ps1"</pre> | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kv_secret_login"></a> [kv\_secret\_login](#output\_kv\_secret\_login) | Login secret name inside the Cloud Bundle key vault. |
| <a name="output_kv_secret_password"></a> [kv\_secret\_password](#output\_kv\_secret\_password) | Password secret name inside the Cloud Bundle key vault. |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | Virtual Machine ID. |
| <a name="output_virtual_machine_name"></a> [virtual\_machine\_name](#output\_virtual\_machine\_name) | Virtual machine name. |
| <a name="output_virtual_machine_vnic_id"></a> [virtual\_machine\_vnic\_id](#output\_virtual\_machine\_vnic\_id) | Virtual network interface controller ID. |
| <a name="output_kv_name"></a> [kv\_name](#output\_kv\_name) |Credentials Azure key vault Name. |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
