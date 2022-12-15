locals {
  vm_name                     = "S${substr(data.azurerm_resource_group.rg_target.tags["environment"], 0, 1)}${data.azurerm_resource_group.rg_target.tags["guid"]}${var.index}"
  environment                 = lower(data.azurerm_resource_group.rg_target.tags["environment"])
  app_name                    = lower(data.azurerm_resource_group.rg_target.tags["app_name"])
  location                    = lower(data.azurerm_resource_group.rg_target.location)
  osfactory_image_name        = var.os_version
  gallery_name                = "gal_infra_os_factory"
  gallery_resource_group_name = "rg-infra-compute-gallery-northeurope"
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
    reboot_hebdo               = var.reboot_hebdo
    availability               = var.availability
    classification             = var.classification
    os_type                    = var.os_type
    os_version                 = var.os_version
    deployed_by                = var.deployed_by
    CloudGuard-FusionInventory = var.tags_cloudguard["fusion_inventory"]
  }
  virtual_machine_tags_cbapp = {
    role                       = var.role
    environment                = local.environment
    reboot_hebdo               = var.reboot_hebdo
    availability               = var.availability
    classification             = var.classification
    os_version                 = var.os_version
    os_type                    = var.os_type
    deployed_by                = var.deployed_by
    CloudGuard-FusionInventory = var.tags_cloudguard["fusion_inventory"]
    CloudGuard-Internet        = var.tags_cloudguard["internet"]
  }
  validate_os_disk_type = length(regexall("[^.].*[sS].*", var.size)) == 0 ? contains(["Standard_LRS", "StandardSSD_LRS", "StandardSSD_ZRS"], var.os_disk_type) ? "isOK" : tobool("Requested operation cannot be performed because the VM size (${var.size}) does not support the storage account type ${var.os_disk_type}. Consider updating the VM to a size that supports Premium storage.") : "isOK"
  validate_data_disk    = [for disk in var.data_disk : length(regexall("[^.].*[sS].*", var.size)) == 0 ? contains(["Standard_LRS", "StandardSSD_LRS", "StandardSSD_ZRS"], disk.type) ? "isOK" : tobool("Requested operation cannot be performed because the VM size (${var.size}) does not support the storage account type ${disk.type}. Consider updating the VM to a size that supports Premium storage.") : "isOK"]
}
