# ================= Azure ==================

variable "cloudbundle_info" {
  description = <<EOF
  **Cloud Bundle target datasource.**
  - Example:
```
data "azurerm_resource_group" "main" {
  name = "rg-RG_NAME-dev"
}

module "virtual_machine" {
  ...
  cloudbundle_info = data.azurerm_resource_group.main
}
```
EOF
}

variable "create_default_keyvault" {
  type        = bool
  description = <<EOF
  **Whether or not a key vault should be created before deploying the virtual machine.**
  - Constraint:
  Valid values for create_default_keyvault are [true | false]
  If `create_default_keyvault = false`, `keyvault_name` value must be provided to the module.
  - Example:
```
create_default_keyvault = true
```
EOF
  default     = true
}

variable "keyvault_name" {
  type        = string
  description = <<EOF
  **Name of an existing Azure Key Vault in which the virtual machines credentials should be stored .**
  - Example:
```
keyvault_name = "mycustomkv"
```
EOF
  default     = ""
}

# ================= Virtual Machine ==================

variable "index" {
  type        = number
  description = <<EOF
  **Virtual Machine index (used to determine the Virtual Machine name).**
  - Constraint:
  Valid values for index are between [001..999]
  - Example:
```
index = 001
```
EOF

  validation {
    condition     = var.index >= 1 && var.index <= 999 && floor(var.index) == var.index
    error_message = "Valid values for var: index are (between 1 to 999)."
  }
}

variable "size" {
  type        = string
  description = <<EOF
  **Virtual Machine size (https://docs.microsoft.com/en-us/azure/virtual-machines/sizes).**
  - Constraint:
  Valid values for size must be avavailable in the Cloud Bundle target region.
  ```
  # List all Virtual Machine sizes available in northeurope
  az vm list-sizes --location "northeurope" --query "[].name"
  ```
  ```
  # Search for a specific size in northeurope
  az vm list-sizes --location "northeurope" --query "[?name=='Standard_DC8_v2']"
  ```
  - Example:
```
size = "Standard_D2s_v3"
```
EOF

  validation {
    condition     = !contains(["Standard_B2ats_v2", "Standard_B2ts_v2", "Standard_B1ls", "Standard_B1s"], var.size)
    error_message = "This size is not allowed. Please, select any size that have a Ram > 1"
  }
}

variable "subnet" {
  type        = string
  description = <<EOF
  **By default, if the 'subnet' argument is not defined, the Virtual Machine will be deployed directly in the main subnet of the Cloud Bundle. However, if the 'subnet' argument is specified, the Virtual Machine will be deployed in the designated subnet.**
  - Example:
```
subnet = "snet-testvnet-test2-dev"
```
EOF
  default     = ""
}

variable "availability_zone" {
  type        = string
  description = <<EOF
  **Set the Availability Zone for the Virtual Machine.**
  *By default, Azure chose the zone for the customer depending on available hardware.*
  - Constraint:
  Valid values for availability_zone are ["1" | "2" | "3"]
  - Example:
```
availability_zone = "1"
```
EOF
  default     = ""

  validation {
    condition     = contains(["", "1", "2", "3"], var.availability_zone)
    error_message = "Valid values for variable availability_zone are: (\"1\", \"2\", \"3\")."
  }
}

variable "os" {
  type = object({
    type    = string
    version = string
  })
  description = <<EOF
  **Virtual Machine Operating System type and version.**
  - Constraint:
  Valid values for os are [{ type = "Ubuntu", version = "2204" } | { type = "Windows", version = "2019" } | { type = "Windows", version = "2022" } | { type = "Rocky", version = "8" } | { type = "Rocky", version = "9" } | { type = "Redhat", version = "9" }]
  - Example:
```
os = {
  type = "Windows"
  version = "2022"
}
```
EOF
  validation {
    condition     = contains([{ type = "Ubuntu", version = "2204" }, { type = "Windows", version = "2019" }, { type = "Windows", version = "2022" }, { type = "Rocky", version = "8" }, { type = "Rocky", version = "9" } ,{ type = "Redhat", version = "9" }], var.os)
    error_message = "Valid values for var: os are  {type = \"Ubuntu\", version = \"2204\"}, {type = \"Windows\", version = \"2019\"}, {type = \"Windows\", version = \"2022\"}, { type = \"Rocky\", version = \"8\"}, { type = \"Rocky\", version = \"9\"}, { type = \"Redhat\", version = \"9\"})."
  }
}

variable "data_disk" {
  type = map(object({
    size = number
    type = string
    lun  = number
  }))
  description = <<EOF
  **Virtual Machine data disk(s).**
  - Example:
```
data_disk = {
  "1" = {
    lun = 1
    type = "Standard_LRS"
    size = 5
  }
} 
```
EOF
  default     = {}
}

variable "os_disk_type" {
  type        = string
  description = <<EOF
  **Virtual Machine Operating System disk type.**
  - Constraint:
  Valid values for os_disk_type are ["Premium_LRS" | "Standard_LRS" | "StandardSSD_LRS" | "StandardSSD_ZRS" | "Premium_ZRS"]
  - Example:
```
os_disk_type = "Standard_LRS"
```
EOF
  default     = "Standard_LRS"
  validation {
    condition     = contains(["Standard_LRS", "Premium_LRS", "StandardSSD_LRS", "StandardSSD_ZRS", "Premium_ZRS"], var.os_disk_type)
    error_message = "Valid values for var: os_disk_type are (Premium_LRS, Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_ZRS)."
  }
}
variable "role" {
  type        = string
  description = <<EOF
  **Virtual Machine role.**
  - Example:
```
role = "webserver"
```
EOF
}

variable "availability" {
  type        = string
  description = <<EOF
  **Virtual Machine desired availability.**
  - Constraint:
  Valid values for availability are ["24/24 - 7/7" | "businessday" | "self-care" | "sleep" ]
  - Example:
```
availability = "businessday"
```
EOF
  default     = "businessday"
  validation {
    condition     = contains(["24/24 - 7/7", "businessday", "self-care", "sleep"], var.availability)
    error_message = "Valid values for var: availability are (24/24 - 7/7, businessday, self-care, sleep)."
  }
}

variable "availability_set_id" {
  type        = string
  description = <<EOF
  **Availability Set ID to attach the Virtual Machine to.**
  - Example:
```
module "availability_set" {
  ...
}

module "virtual_machine" {
  ...
  availability_set_id = module.availability_set.id
}
```
EOF
  default     = null
}

variable "weekly_reboot" {
  type        = string
  description = <<EOF
  **Virtual Machine weekly reboot.**
  *Default reboot time is every Tuesday at 4AM (2.4).*
  *Find more details here : WIKI/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#*
  - Constraint:
  Valid values for weekly_reboot are "[1..5].[0..23]"
  - Example:
```
# Reboot every wednesday at 3AM
weekly_reboot = "3.3"
```
EOF
  default     = "2.4"
}

variable "start" {
  type        = string
  description = <<EOF
  **Virtual Machine desired start.**
  *Find more details here : WIKI/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#*
  - Constraint:
  Valid values for start are ["1.[0..23]","2.[0..23]","3.[0..23],"4.[0..23]","5.[0..23]" | "No"]
  This parameter must be used only if ```availability = "businessday"```
  - Example:
```
availability = "businessday"
# Start Virtual Machine every weekday at 7AM
start        = "1.7,2.7,3.7,4.7,5.7"
```
EOF
  default     = ""
}

variable "stop" {
  type        = string
  description = <<EOF
  **Virtual Machine desired stop.**
  *Find more details here : WIKI/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#*
  - Constraint:
  Valid values for stop are ["1.[0..23]","2.[0..23]","3.[0..23],"4.[0..23]","5.[0..23]" | "No"]
  This parameter must be used only if ```availability = "businessday"```
  - Example:
```
availability = "businessday"
# Stop Virtual Machine every weekday at 7PM
stop        = "1.19,2.19,3.19,4.19,5.19"
```
EOF
  default     = ""
}

variable "backup" {
  type        = string
  description = <<EOF
  **Enabling Virtual Machine backup.**
  - Constraint:
  Valid values for backup are ["true" | "false"]
  - Example:
```
backup = "true"
```
EOF
  default     = "false"
  validation {
    condition     = contains(["false", "true"], var.backup)
    error_message = "Valid values for var: backup are (true, false)."
  }
}

variable "deployed_by" {
  type        = string
  description = <<EOF
  **Virtual Machine information, do not modify.**
  - Constraint:
  Valid values for deployed_by are ["VMaaS" | "Test_by_VMaaS"]
  - Example:
```
deployed_by = "VMaaS"
```
EOF
  default     = "VMaaS"
  validation {
    condition     = contains(["VMaaS", "Test_by_VMaaS"], var.deployed_by)
    error_message = "Valid values for var: deployed_by are: VMaaS."
  }
}

variable "tags" {
  type        = map(string)
  description = <<EOF
    **Virtual Machine user-defined tags.**
    *Default value for this variable is null.*
    *Find more details here : WIKI/Cloud%20Documentation/_wiki/wikis/Cloud-Documentation.wiki/7086/How-to-add-custom-tags-to-a-Virtual-Machine*

    - Constraint:
      You can apply up to 50 tags to a resource in Azure. 
      Make sure that the number of tags does not exceed 50 when adding custom tags.
      To access further information, please refer to https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits
    
    - Example: 
  ```
  tags = {
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  }
  ```
  EOF
  nullable    = true
  default     = null
}

variable "start_sequence" {
  type        = number
  description = <<EOF
  **Virtual Machine start scheduling sequence.**
  *Default start sequence is null. No start sequence will be applied unless you specifically choose one*
  *Find more details here : WIKI/Cloud%20Documentation/_wiki/wikis/Cloud-Documentation.wiki/6263/How-to-automate-VM-Start-Stop-Reboot-?anchor=advance*
  - Constraint:
  Valid values for start_sequence are "[1..n]", with n > 0
  - Example:
```
# Start the current Virtual Machine first
start_sequence = 1
```
EOF
  nullable    = true
  default     = null

  validation {
    condition     = var.start_sequence == null ? true : (var.start_sequence > 0)
    error_message = "Valid values for var: start_sequence are (between 1 to n), where n > 0."
  }
}


variable "stop_sequence" {
  type        = number
  description = <<EOF
    **Virtual Machine shutdown scheduling sequence.**
    *Default shutdown sequence is null. No shutdown sequence will be applied unless you specifically choose one*
    *Find more details here : WIKI/Cloud%20Documentation/_wiki/wikis/Cloud-Documentation.wiki/6263/How-to-automate-VM-Start-Stop-Reboot-?anchor=advance*
    - Constraint:
    Valid values for stop_sequence are "[1..n]", with n > 0
    - Example:
  ```
  # Stop the current Virtual Machine first
  stop_sequence = 1
  ```
  EOF
  nullable    = true
  default     = null

  validation {
    condition     = var.stop_sequence == null ? true : (var.stop_sequence > 0)
    error_message = "Valid values for var: stop_sequence are (between 1 to n), where n > 0."
  }
}

# ================= Virtual Machine post-configuration ==================

variable "cloudinit_parts" {
  description = <<EOF
  **Virtual Machine cloud-init configuration for Linux Operating System.**
  A list of maps that contain the information for each part in the cloud-init configuration.
  Each map should have the following fields:
  `content-type` - type of content for this part, e.g. `text/x-shellscript` => https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config#content_type
  `filepath` - path to the file to use as a template
  `vars` - map of variables to use with the part template
  - Constraint:
  Valid values must be configured for `content-type`, `filepath`, `vars` (see the link above).
  - Example:
```
cloudinit_parts = [
  {
      filepath = "./startup-script.sh"
      content-type = "text/x-shellscript"
      vars = {
        var_name = "var_value"
      }
  }
]
```
EOF
  type = list(object({
    content-type = string
    filepath     = string
    vars         = map(string)
  }))
  default = []
}

variable "windows_postinstall_script" {
  description = <<EOF
  **Virtual Machine post-configuration script for Windows Operating System.**
  *Provide a path to a PowerShell script that Terraform will copy on the Virtual Machine and then execute.*
  - Constraint:
  os.type = "Windows"
  - Example:
```
windows_postinstall_script = "./startup-script.ps1"
```
EOF
  type        = string
  default     = ""
}

# ================= Active Directory ==================

variable "ad_domain" {
  type        = string
  description = <<EOF
  **Virtual Machine target Active Directory domain name or workgroup.**
  - Constraint:
  Valid values for ad_domain are [DomainName | workgroup]
  - Example:
```
ad_domain = "mydomain.local"
```
EOF
}

variable "remote_desktop_readers" {
  type        = string
  description = <<EOF
  **Comma separated list of read only users to add to the Remote Desktop Users group.**
  - Constraint:
  The specified user names must be existing privileged accounts.

  - Example:
```
remote_desktop_readers = "account1, account2"
```
EOF

  default     = ""

}

variable "remote_desktop_administrators" {
  type        = string
  description = <<EOF
  **Comma separated list of users with administrator permission to add to the Remote Desktop Users group.**
  - Constraint:
  The specified user names must be existing privileged accounts.

  - Example:
```
remote_desktop_administrators = "account1, account2"
```
EOF

  default     = ""

}


# ================= Bastion ==================

variable "is_accessible_from_bastion" {
  type        = bool
  description = <<EOF
  **Add the Virtual Machine to the bastion.**
  - Constraint:
  Valid values for is_accessible_from_bastion are [true | false]
  If `is_accessible_from_bastion = true`, `bastion_allowed_ba_entities` value must be provided to the module.
  If `is_accessible_from_bastion = true` and ad_domain != "workgroup" and os.type = "Windows", `bastion_allowed_ad_entities` or `bastion_allowed_ad_groups` value must be provided to the module.
  - Example:
```
ad_domain = "DomainName"
is_accessible_from_bastion = true
bastion_allowed_ba_entities = "BastionAccount1,BastionAccount2"
bastion_allowed_ad_entities = "ADAccount1,ADAccount1"
```
EOF
  default     = false
}

variable "bastion_allowed_ba_entities" {
  type        = string
  description = <<EOF
  **Bastion account(s) list that will be used to access bastion.**
  Provide a list of valid bastion account(s).
  - Example:
```
bastion_allowed_ba_entities = "BastionAccount1,BastionAccount2"
```
EOF
  default     = ""
}

variable "bastion_allowed_ad_entities" {
  type        = string
  description = <<EOF
  **Active Directory Application account(s) list that will be used by bastion to access the Virtual Machine.**
  - Constraint:
  ad_domain != "workgroup"
  Provide a list of valid Active Directory Application account(s) that will access the Virtual Machine.
  - Example:
```
bastion_allowed_ad_entities = "ADAccount1,ADAccount1"
```
EOF
  default     = ""
}

variable "bastion_allowed_ad_groups" {
  type        = string
  description = <<EOF
  **Active Directory Application group(s) list that will be used by bastion to access the Virtual Machine.**
  - Constraint:
  ad_domain != "workgroup"
  Provide a list of valid Active Directory Application group(s) that will access the Virtual Machine.
  - Example:
```
bastion_allowed_ad_groups = "ADGroup1,ADGroup1"
```
EOF
  default     = ""
}

# ================= Network ==================

variable "tags_cloudguard" {
  type        = map(any)
  description = <<EOF
  **Open network flows for the Virtual Machine**
  *Find more details here: WIKI/Cloud%20Documentation/_wiki/wikis/Cloud-Documentation.wiki/6066/From-OS-Shared-Image-Gallery?anchor=set-virtual-machine%27s-tags#*
  - Constraint:
  Valid values for tags_cloudguard are 
  [{
    "fusion_inventory" = ["TRUE" | "FALSE"]
    "internet"         = ["REGULAR" | "LARGE"]
  }]
  - Example:
```
tags_cloudguard = {
  "fusion_inventory" = "TRUE"
  "internet"         = "REGULAR"
}
```
EOF
  default = {
    "fusion_inventory" = "TRUE"
    "internet"         = "REGULAR"
  }
}

# ================= AWX ==================

variable "playbook_list" {
  type        = string
  description = <<EOF
  **Playbook(s) from the OS Automation Tower marketplace to apply to the Virtual Machine after deployment.**
  - Constraint:
  The specified playbook name(s) must exist in the OS Automation Tower marketplace.
  - Example:
```
playbook_list = "playbook1,playbook2"
```
EOF
  default     = ""
}
