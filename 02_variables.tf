# ================= Azure ==================

variable "resource_group_name" {
  type        = string
  description = "Target resource group name"
}

variable "gallery_subscription_id" {
  type        = string
  description = "(Optional) Azure compute gallery subscription ID"
  default     = ""
}

# ================= Virtual Machine ==================

variable "index" {
  type        = number
  description = "Index of the VM"
  validation {
    condition     = var.index >= 1 && var.index <= 999 && floor(var.index) == var.index
    error_message = "Valid values for var: index are (between 1 to 999)."
  }
}

variable "size" {
  type        = string
  description = "VM size (https://docs.microsoft.com/en-us/azure/virtual-machines/sizes)."
}


variable "subnet" {
  type        = string
  description = "(Optional) By default, if the 'subnet' argument is not defined, the VM will be deployed directly in the main subnet of the Cloud Bundle. However, if the 'subnet' argument is specified, the VM will be deployed in the designated subnet."
  default     = ""
}

variable "availability_zone" {
  type        = string
  description = "(Optional) Set the availability zone for the Virtual Machine. By default, value is empty, Azure chose the zone for the customer depending on available hardware."
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
  description = "OS type and version"

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
  description = "(Optional) Map of data disk(s)"
  default     = {}
}

variable "os_disk_type" {
  type        = string
  description = "(Optional) VM OS disk type => Premium_LRS, Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_ZRS"
  default     = "Standard_LRS"
  validation {
    condition     = contains(["Standard_LRS", "Premium_LRS", "StandardSSD_LRS", "StandardSSD_ZRS", "Premium_ZRS"], var.os_disk_type)
    error_message = "Valid values for var: os_disk_type are (Premium_LRS, Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_ZRS)."
  }
}
variable "role" {
  type        = string
  description = "VM role => frontend, backend, etc..."
}



variable "availability" {
  type        = string
  description = "VM desired availability => 24/24 - 7/7, businessday, self-care, sleep"
  default     = "businessday"
  validation {
    condition     = contains(["24/24 - 7/7", "businessday", "self-care", "sleep"], var.availability)
    error_message = "Valid values for var: availability are (24/24 - 7/7, businessday, self-care, sleep)."
  }
}

variable "create_availability_set" {
  type    = bool
  description = "Create a new Availability Set and attach the Virtual Machine to it."
  default = false
}
variable "availability_set_name" {
  type    = string
  description = "Set the existing Availabilty Set to attach it to the Virtual Machine."
  default = ""
}

variable "reboothebdo" {
  type        = string
  description = <<EOF
  (Optional) Default reboot time is every Tuesday at 4AM (2.4). In order to update day and time, use this parameter. 
  "VM reboot time => [1-5].[0-23], No"
  Find more details here : WIKI/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#
  EOF
  default     = "2.4"
}

variable "start" {
  type        = string
  description = <<EOF
  (Optional) Use this parameter only if availability = "businessday".
  "VM desired start => [1-5].[0-23],[1-5].[0-23],[1-5].[0-23],[1-5].[0-23], No"
  Example for VM that will be started at 7AM on Thursday and all others workdays at 5AM: 
    availability = "businessday"
    start        = "1.5,2.5,3.5,4.7,5.5"
  Find more details here : WIKI/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#
  EOF
  default     = ""
}

variable "stop" {
  type        = string
  description = <<EOF
  (Optional) Use this parameter only if availability = "businessday".
  "VM desired stop => [1-5].[0-23],[1-5].[0-23],[1-5].[0-23],[1-5].[0-23], No"
  Example for VM that will be stopped at 5PM on Thursday and all others workdays at 11PM: 
    availability = "businessday"
    start        = "1.23,2.23,3.23,4.23,5.17"
  Find more details here : WIKI/Cloud%20Documentation/_wiki?pageId=6263&friendlyName=How-to-automate-VM-Start-Stop-Reboot-#
  EOF
  default     = ""
}


variable "backup" {
  type        = string
  description = "(Optional) VM backup enable or not => true, false"
  default     = "false"
  validation {
    condition     = contains(["false", "true"], var.backup)
    error_message = "Valid values for var: backup are (true, false)."
  }
}

variable "deployed_by" {
  type        = string
  description = "(Optional) VM information => VMaaS, Test_by_VMaaS"
  default     = "VMaaS"
  validation {
    condition     = contains(["VMaaS", "Test_by_VMaaS"], var.deployed_by)
    error_message = "Valid values for var: deployed_by are: VMaaS."
  }
}

variable "ad_domain" {
  type        = string
  description = "add vm on ad domain or workgroup"
  default     = ""
  validation {
    condition     = contains(["workgroup", "fr.green.local", "green.local"], var.ad_domain)
    error_message = "Valid values for var: green.local, fr.green.local or workgroup."
  }
}

variable "cloudinit_parts" {
  description = <<EOF
(Optional) A list of maps that contain the information for each part in the cloud-init configuration.
Each map should have the following fields:
* content-type - type of content for this part, e.g. text/x-shellscript => https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config#content_type
* filepath - path to the file to use as a template
* vars - map of variables to use with the part template
  EOF

  type = list(object({
    content-type = string
    filepath     = string
    vars         = map(string)
  }))
  default = []
}

variable "windows_postinstall_script" {
  description = "Path to a file that Terraform will copy on the VM and then execute, eg. to install a IIS server and set it up and running"
  type        = string
  default     = ""
}

# ================= Ad tags ==================

variable "wallix_client" {
  type    = bool
  default = false
}
variable "wallix_ad_account" {
  type        = string
  description = "This variable is mandatory when wallix_client is true"
  default = ""

}
variable "wallix_ba_account" {
  type        = string
  description = "This variable is mandatory when wallix_client is true"
  default = ""
}



# ================= Network ==================

variable "tags_cloudguard" {
  type        = map(any)
  description = "(Optional) VM network flows => find more details here : WIKI/Cloud%20Documentation/_wiki/wikis/Cloud-Documentation.wiki/6066/From-OS-Shared-Image-Gallery?anchor=set-virtual-machine%27s-tags# "
  default = {
    "fusion_inventory" = "TRUE"
    "internet"         = "REGULAR"
  }
}
