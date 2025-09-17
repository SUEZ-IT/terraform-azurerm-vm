locals {
  vm_name              = "S${substr(upper(var.cloudbundle_info.tags["environment"]), 0, 1)}${var.cloudbundle_info.tags["guid"]}${var.index}"
  environment          = lower(var.cloudbundle_info.tags["environment"])
  app_name             = lower(var.cloudbundle_info.tags["app_name"])
  app_family           = lower(var.cloudbundle_info.tags["app_family"])
  location             = lower(var.cloudbundle_info.location)
  service_level        = lower(var.cloudbundle_info.tags["service_level"])

  location_msp_mapping = [
    { location = "northeurope", inframsp = "neu", code = "neu" },
    { location = "francecentral", inframsp = "fce", code = "fce" },
    { location = "australiaeast", inframsp = "australiaeast", code = "aea" },
    { location = "germanywestcentral", inframsp = "germanywestcentral", code = "gwc" }
  ]

  location_msp                = [for x in local.location_msp_mapping : x.inframsp if x.location == local.location]
  code_msp                    = [for x in local.location_msp_mapping : x.code if x.location == local.location]
  managed_by_cap              = strcontains(lower(coalesce(var.cloudbundle_info.tags["operating_mode"], "it-gis-cde:it-gis-cde:unknown")), "capmsp")
  subscription_digit          = substr(data.azurerm_subscription.current.display_name, 3, 2)
  plan_name                   = (var.os.type == "Rocky" && var.os.version == "9" ? "9-base" : "8-base")
  plan_product                = "rockylinux-x86_64"
  plan_publisher              = "resf"
  gallery_name                = "gal_infra_os_factory"
  gallery_resource_group_name = "rg-infra-compute-gallery-northeurope"
  group_RO                    = "SG-GLOB-VMaaS-${var.cloudbundle_info.name}-${local.vm_name}-RO"
  group_RW                    = "SG-GLOB-VMaaS-${var.cloudbundle_info.name}-${local.vm_name}-RW"

  image_mapping = [
    { image = "WindowsServer2022Datacenter", type = "Windows", version = "2022" },
    { image = "UbuntuServer2204", type = "Ubuntu", version = "2204" },
    { image = "RockyLinux8", type = "Rocky", version = "8" },
    { image = "RockyLinux9", type = "Rocky", version = "9" },
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
  cloud_init_config = base64gzip(templatefile("${path.module}/../../templates/cloud-init.tpl", { cloud_init_parts = local.cloud_init_parts_rendered }))

  version = "10.1.0"
  virtual_machine_tags_cblab = merge({
    role                          = var.role
    environment                   = local.environment
    weekly_reboot                 = var.weekly_reboot
    availability                  = var.availability
    os_type                       = var.os.type
    deployed_by                   = var.deployed_by
    CloudGuard-FusionInventory    = var.tags_cloudguard["fusion_inventory"]
    start                         = var.start != "" ? var.start : null
    stop                          = var.stop != "" ? var.stop : null
    ad_domain                     = var.ad_domain
    playbook_list                 = var.playbook_list
    version                       = local.version
    start_sequence                = var.start_sequence
    stop_sequence                 = var.stop_sequence
    is_default_keyvault_created   = var.create_default_keyvault
    client_keyvault_name          = (!var.create_default_keyvault && var.keyvault_name != "") ? var.keyvault_name : null
    remote_desktop_readers        = (length(trimspace(var.remote_desktop_readers)) > 0) ? lower(trimspace(var.remote_desktop_readers)) : null
    remote_desktop_administrators = (length(trimspace(var.remote_desktop_administrators)) > 0) ? lower(trimspace(var.remote_desktop_administrators)) : null
    local_group_RO                = (length(trimspace(var.remote_desktop_readers)) > 0) ? local.group_RO : null
    local_group_RW                = (length(trimspace(var.remote_desktop_readers)) > 0) ? local.group_RW : null
  }, var.tags)
  virtual_machine_tags_cbapp = merge({
    role                          = var.role
    environment                   = local.environment
    weekly_reboot                 = var.weekly_reboot
    availability                  = var.availability
    os_type                       = var.os.type
    deployed_by                   = var.deployed_by
    CloudGuard-FusionInventory    = var.tags_cloudguard["fusion_inventory"]
    CloudGuard-Internet           = var.tags_cloudguard["internet"]
    start                         = var.start != "" ? var.start : null
    stop                          = var.stop != "" ? var.stop : null
    ad_domain                     = var.ad_domain
    playbook_list                 = var.playbook_list
    is_accessible_from_bastion    = var.is_accessible_from_bastion
    bastion_allowed_ba_entities   = var.bastion_allowed_ba_entities
    bastion_allowed_ad_entities   = var.bastion_allowed_ad_entities
    bastion_allowed_ad_groups     = var.bastion_allowed_ad_groups
    version                       = local.version
    start_sequence                = var.start_sequence
    stop_sequence                 = var.stop_sequence
    is_default_keyvault_created   = var.create_default_keyvault
    client_keyvault_name          = (!var.create_default_keyvault && var.keyvault_name != "") ? var.keyvault_name : null
    remote_desktop_readers        = (length(trimspace(var.remote_desktop_readers)) > 0) ? lower(trimspace(var.remote_desktop_readers)) : null
    remote_desktop_administrators = (length(trimspace(var.remote_desktop_administrators)) > 0) ? lower(trimspace(var.remote_desktop_administrators)) : null
    local_group_RO                = (length(trimspace(var.remote_desktop_readers)) > 0) ? local.group_RO : null
    local_group_RW                = (length(trimspace(var.remote_desktop_administrators)) > 0) ? local.group_RW : null
  }, var.tags)
  validate_os_disk_type = length(regexall("[^.].*[sS].*", var.size)) == 0 ? contains(["Standard_LRS", "StandardSSD_LRS", "StandardSSD_ZRS"], var.os_disk_type) ? "isOK" : tobool("Requested operation cannot be performed because the Virtual Machine size (${var.size}) does not support the storage account type ${var.os_disk_type}. Consider updating the Virtual Machine to a size that supports Premium storage.") : "isOK"
  validate_data_disk    = [for disk in var.data_disk : length(regexall("[^.].*[sS].*", var.size)) == 0 ? contains(["Standard_LRS", "StandardSSD_LRS", "StandardSSD_ZRS"], disk.type) ? "isOK" : tobool("Requested operation cannot be performed because the Virtual Machine size (${var.size}) does not support the storage account type ${disk.type}. Consider updating the Virtual Machine to a size that supports Premium storage.") : "isOK"]

  # Backup locals
  vault_redundancy_suffix = contains(["gold", "platinum"], local.service_level) ? "" : "-zrs"
  vault_backup_name = local.managed_by_cap ? "rsv-${local.environment}${local.subscription_digit}-${local.code_msp[0]}-msp-${local.subscription_digit}${local.vault_redundancy_suffix}" : "rsv-${local.app_name}-${local.environment}"
  vault_backup_rg_name =  local.managed_by_cap ? data.azurerm_resource_group.inframsp[0].name : var.cloudbundle_info.name
  backup_policy_mapping = {
    "dev" = {
      "bronze" = "noprd-weekly",
      "silver" = "noprd-daily",
      "gold" = "noprd-daily",
      "platinum" = "noprd-daily"
    },
    "rec" = {
      "bronze" = "noprd-weekly",
      "silver" = "noprd-daily",
      "gold" = "noprd-daily",
      "platinum" = "noprd-daily"
    },
    "prd" = {
      "bronze" = "prd-weekly",
      "silver" = "prd-daily-short",
      "gold" = "prd-daily-short",
      "platinum" = "prd-daily-short"
    }
  }

  default_backup_policy_name   = local.managed_by_cap ? lookup(lookup(local.backup_policy_mapping, local.environment, {}), local.service_level, "DefaultPolicy") : "DefaultPolicy"
  enable_backup                = var.backup == "true" && local.environment != "sbx" && local.environment != "hml"

  actual_virtual_machine = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0] : azurerm_linux_virtual_machine.virtual_machine[0]


  windows_winrm_script         = "${path.module}/../../scripts/ConfigureWinRM.ps1"
  win_post_deploy_scripts_path = (var.windows_postinstall_script == "" ? ["${local.windows_winrm_script}"] : ["${local.windows_winrm_script}", "${var.windows_postinstall_script}"])

  win_post_deploy_script_command = "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \\\"cp c:/azuredata/customdata.bin c:/azuredata/install.zip; Expand-Archive -Force -Path c:/azuredata/install.zip -DestinationPath c:/temp ; Get-ChildItem c:/temp -Filter '*.ps1' | ForEach-Object {& $_.FullName}\\\""

  update_management_configuration = {
    patchSettings = {
      assessmentMode   = "AutomaticByPlatform"
      patchMode        = "AutomaticByPlatform"
      provisionVMAgent = true

      automaticByPlatformSettings = {
        bypassPlatformSafetyChecksOnUserSchedule = true
      }
    }
  }
}
