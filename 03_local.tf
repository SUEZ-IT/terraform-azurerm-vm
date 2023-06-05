locals {
  vm_name     = "S${substr(data.azurerm_resource_group.rg_target.tags["environment"], 0, 1)}${data.azurerm_resource_group.rg_target.tags["guid"]}${var.index}"
  environment = data.azurerm_resource_group.rg_target.tags["environment"]
  app_name    = lower(data.azurerm_resource_group.rg_target.tags["app_name"])
  location    = lower(data.azurerm_resource_group.rg_target.location)
  location_msp_mapping = [
    { location = "northeurope", inframsp = "neu", code = "neu" },
    { location = "francecentral", inframsp = "fce", code = "fce" },
    { location = "australiaeast", inframsp = "australiaeast", code = "aea" },
    { location = "germanywestcentral", inframsp = "germanywestcentral", code = "gwc" }
  ]
  location_msp                = [for x in local.location_msp_mapping : x.inframsp if x.location == local.location]
  code_msp                    = [for x in local.location_msp_mapping : x.code if x.location == local.location]
  managed_by_cap              = contains(["yes", "true"], lower(data.azurerm_resource_group.rg_target.tags["managed_by_capmsp"])) ? true : false
  subscription_digit          = substr(data.azurerm_subscription.current.display_name, 3, 2)
  plan_name                   = "free"
  plan_product                = "rockylinux"
  plan_publisher              = "erockyenterprisesoftwarefoundationinc1653071250513"
  gallery_name                = "gal_infra_os_factory"
  gallery_resource_group_name = "rg-infra-compute-gallery-northeurope"
  image_mapping = [
    { image = "WindowsServer2019Datacenter", type = "Windows", version = "2019" },
    { image = "WindowsServer2022Datacenter", type = "Windows", version = "2022" },
    { image = "WindowsServer2022Datacenter-gen2", type = "Windows", version = "2022gen2" },
    { image = "UbuntuServer2204", type = "Ubuntu", version = "2204" },
    { image = "RockyLinux8", type = "Rocky", version = "8" },
    { image = "RedHatEnterprise9", type = "Redhat", version = "9" }

  ]
  osfactory_image_name = [for x in local.image_mapping : x.image if x.type == var.os.type && x.version == var.os.version]


  cloudbundle_type = {
    "Enabled"   = "ce"
    "Optimized" = "co"
  }
  cloud_init_parts_rendered = [for part in var.cloudinit_parts : <<EOF
--MIMEBOUNDARY
Content-Transfer-Encoding: 7bit
Content-Type: ${part.content-type}
Mime-Version: 1.0
${templatefile(part.filepath, part.vars)}
    EOF
  ]
  cloud_init_config = base64gzip(templatefile("${path.module}/scripts/cloud-init.tpl", { cloud_init_parts = local.cloud_init_parts_rendered }))

  virtual_machine_tags_cblab = {
    role                       = var.role
    environment                = local.environment
    reboothebdo                = var.reboothebdo
    availability               = var.availability
    classification             = var.classification
    os_type                    = var.os.type
    deployed_by                = var.deployed_by
    CloudGuard-FusionInventory = var.tags_cloudguard["fusion_inventory"]
    start                      = var.start != "" ? var.start : null
    stop                       = var.stop != "" ? var.stop : null
    ad_domain                  = var.ad_domain
  }
  virtual_machine_tags_cbapp = {
    role                       = var.role
    environment                = local.environment
    reboothebdo                = var.reboothebdo
    availability               = var.availability
    classification             = var.classification
    os_type                    = var.os.type
    deployed_by                = var.deployed_by
    CloudGuard-FusionInventory = var.tags_cloudguard["fusion_inventory"]
    CloudGuard-Internet        = var.tags_cloudguard["internet"]
    start                      = var.start != "" ? var.start : null
    stop                       = var.stop != "" ? var.stop : null
    ad_domain                  = var.ad_domain
    wallix_client = var.wallix_client
    wallix_ad_account          = var.wallix_ad_account
    wallix_ba_account          = var.wallix_ba_account
  }
  validate_os_disk_type = length(regexall("[^.].*[sS].*", var.size)) == 0 ? contains(["Standard_LRS", "StandardSSD_LRS", "StandardSSD_ZRS"], var.os_disk_type) ? "isOK" : tobool("Requested operation cannot be performed because the VM size (${var.size}) does not support the storage account type ${var.os_disk_type}. Consider updating the VM to a size that supports Premium storage.") : "isOK"
  validate_data_disk    = [for disk in var.data_disk : length(regexall("[^.].*[sS].*", var.size)) == 0 ? contains(["Standard_LRS", "StandardSSD_LRS", "StandardSSD_ZRS"], disk.type) ? "isOK" : tobool("Requested operation cannot be performed because the VM size (${var.size}) does not support the storage account type ${disk.type}. Consider updating the VM to a size that supports Premium storage.") : "isOK"]

  ostype                 = var.os.type == "Windows" ? "w" : "l"
  datacollectionrulename = format("am-dcr-%s-%s-%s%s", local.ostype, local.location_msp[0], local.environment, local.subscription_digit)

  rsv_mapping = [
    { availability = "self-care", env = "DEV", policy = "Policy1453-SelfCare-STD" },
    { availability = "self-care", env = "REC", policy = "Policy1453-SelfCare-STD" },
    { availability = "self-care", env = "HML", policy = "Policy1453-SelfCare-STD" },
    { availability = "self-care", env = "PRD", policy = "Policy1453-SelfCare-STD" },
    { availability = "24/24 - 7/7", env = "DEV", policy = "Policy1453-247-NonProd-STD" },
    { availability = "24/24 - 7/7", env = "REC", policy = "Policy1453-247-NonProd-STD" },
    { availability = "24/24 - 7/7", env = "HML", policy = "Policy1453-247-NonProd-STD" },
    { availability = "24/24 - 7/7", env = "PRD", policy = "Policy1453-247-Prod-STD" },
    { availability = "businessday", env = "DEV", policy = "Policy1453-BDay-OutProd-STD" },
    { availability = "businessday", env = "REC", policy = "Policy1453-BDay-OutProd-STD" },
    { availability = "businessday", env = "HML", policy = "Policy1453-BDay-OutProd-STD" },
    { availability = "businessday", env = "PRD", policy = "Policy1453-BDay-Prod-STD" }
  ]

  post_deploy_script     = var.os.type == "Windows" ? azurerm_virtual_machine_extension.vm_win_post_deploy_script : azurerm_virtual_machine_extension.vm_lin_post_deploy_script
  actual_virtual_machine = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0] : azurerm_linux_virtual_machine.virtual_machine[0]

  policy_name = local.managed_by_cap ? lookup({ for mapping in local.rsv_mapping : "${mapping.availability}:${mapping.env}" => mapping.policy }, "${var.availability}:${local.environment}", "DefaultPolicy") : "DefaultPolicy"

  win_post_deploy_init_script_command = "powershell ./windows_common.ps1 ${data.azurerm_resource_group.rg_target.tags["managed_by_capmsp"]}" 
  win_post_deploy_script_command = var.windows_postinstall_script != "" ? join(" && ", tolist([local.win_post_deploy_init_script_command, "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \\\"cp c:/azuredata/customdata.bin c:/azuredata/install.ps1; c:/azuredata/install.ps1\\\""])) : local.win_post_deploy_init_script_command 
}


