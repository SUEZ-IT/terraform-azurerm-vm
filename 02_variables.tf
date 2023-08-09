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
}


variable "subnet" {
  type        = string
  description = <<EOF
  **By default, if the 'subnet' argument is not defined, the VM will be deployed directly in the main subnet of the Cloud Bundle. However, if the 'subnet' argument is specified, the VM will be deployed in the designated subnet.**
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
  Valid values for os are [{ type = "Ubuntu", version = "2204" } | { type = "Windows", version = "2019" } | { type = "Windows", version = "2022" } | { type = "Rocky", version = "8" } | { type = "Redhat", version = "9" }]
  - Example:
  ```
  os = {
    type = "Windows"
    version = "2022"
  }
  ```
  EOF
  validation {
    condition     = contains([{ type = "Ubuntu", version = "2204" }, { type = "Windows", version = "2019" }, { type = "Windows", version = "2022" }, { type = "Rocky", version = "8" }, { type = "Redhat", version = "9" }], var.os)
    error_message = "Valid values for var: os are  {type = \"Ubuntu\", version = \"2204\"}, {type = \"Windows\", version = \"2019\"}, {type = \"Windows\", version = \"2022\"}, { type = \"Rocky\", version = \"8\"}, { type = \"Redhat\", version = \"9\"})."
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
  **Virtual Machine Operating System disk type => .**
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
  role = "webserver"
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

variable "reboothebdo" {
  type        = string
  description = <<EOF
  **Virtual Machine weekly reboot.**
  *Default reboot time is every Tuesday at 4AM (2.4).*
  *Find more details here : https://dev.azure.com/suez-it-foundations-cloud/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#*
  - Constraint:
  Valid values for reboothebdo are "[1..5].[0..23]"
  - Example:
  ```
  # Reboot every wednesday at 3AM
  reboothebdo = "3.3"
  ```
  EOF
  default     = "2.4"
}

variable "start" {
  type        = string
  description = <<EOF
  **Virtual Machine desired start.**
  *Find more details here : https://dev.azure.com/suez-it-foundations-cloud/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#*
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
  *Find more details here : https://dev.azure.com/suez-it-foundations-cloud/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#*
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
  os.type = ["Redhat" | "Ubuntu" | "Rocky"]
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
  **Virtual Machine target Active Directory domain name.**
  - Constraint:
  Valid values for ad_domain are ["green.local" | "fr.green.local" | "workgroup"]
  - Example:
  ```
  ad_domain = "green.local"
  ```
  EOF
  validation {
    condition     = contains(["workgroup", "fr.green.local", "green.local"], var.ad_domain)
    error_message = "Valid values for var: green.local, fr.green.local or workgroup."
  }
}

# ================= Wallix bastion ==================
variable "wallix_client" {
  type        = bool
  description = <<EOF
  **Add the Virtual Machine to the Wallix bastion.**
  - Constraint:
  Valid values for wallix_client are [true | false]
  If `wallix_client = true`, `wallix_ad_account` and `wallix_ba_account` values must be provided to the module.
  - Example:
  ```
  ad_domain = "green.local"
  wallix_client = true
  wallix_ad_account = "IA-AAA123"
  wallix_ba_account = "BA-AAA123"
  ```
  EOF
  default     = false
}
variable "wallix_ad_account" {
  type        = string
  description = <<EOF
  **Existing Active Directory Application Admin account that will be used by Wallix bastion to access the Virtual Machine.**
  - Constraint:
  ad_domain != "workgroup"
  Provide an existing Application Admin account on the Virtual Machine target Active Directory.
  - Example:
  ```
  wallix_ad_account = "IA-AAA123"
  ```
  EOF
  default     = ""

}
variable "wallix_ba_account" {
  type        = string
  description = <<EOF
  **Existing Wallix bastion BA account that will be used to access Wallix bastion.**
  - Constraint:
  ad_domain != "workgroup"
  Provide an existing BA account.
  - Example:
  ```
  wallix_ba_account = "BA-AAA123"
  ```
  EOF
  default     = ""
}



# ================= Network ==================

variable "tags_cloudguard" {
  type        = map(any)
  description = <<EOF
  **Open network flows for the Virtual Machine**
  *Find more details here: https://dev.azure.com/suez-it-foundations-cloud/Cloud%20Documentation/_wiki/wikis/Cloud-Documentation.wiki/6066/From-OS-Shared-Image-Gallery?anchor=set-virtual-machine%27s-tags#*
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
