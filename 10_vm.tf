resource "azurerm_network_interface" "VmNic" {
  name                = "nic-${local.vm_name}"
  location            = local.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "nic-${local.vm_name}-conf"
    subnet_id                     = data.azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [null_resource.validation_wallix_ad, null_resource.validation_wallix_ba]
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
  count                 = var.os.type == "Windows" ? 1 : 0
  name                  = local.vm_name
  location              = local.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = ["${azurerm_network_interface.VmNic.id}"]
  size                  = var.size
  admin_username        = azurerm_key_vault_secret.client_credentials_login.value
  admin_password        = azurerm_key_vault_secret.client_credentials_password.value
  tags                  = data.azurerm_resource_group.rg_target.tags["app_family"] == "Application" ? { for key, value in local.virtual_machine_tags_cbapp : key => value if value != "" } : local.virtual_machine_tags_cblab
  source_image_id       = data.azurerm_shared_image.osfactory_image.id
  custom_data           = filebase64(data.archive_file.win_post_deploy_scripts_zipped[0].output_path)
  patch_mode            = "AutomaticByOS"
  zone                  = var.availability_zone != null && var.availability_zone != "" ? var.availability_zone : null
  availability_set_id   = var.availability_zone == "" && var.availability_set_name == "" && var.create_availability_set ? azurerm_availability_set.availabilityset[0].id : length(data.azurerm_availability_set.availability_set) > 0 ? data.azurerm_availability_set.availability_set[0].id : null

  identity {
      type = "SystemAssigned"
  }
  os_disk {
    name                 = "${local.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm_sa.primary_blob_endpoint
  }
  depends_on = [null_resource.validation_wallix_ad, null_resource.validation_wallix_ba]
}

resource "azurerm_virtual_machine_extension" "vm_win_post_deploy_script" {
  count                = var.os.type == "Windows" ? 1 : 0
  name                 = azurerm_windows_virtual_machine.virtual_machine[0].name
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine[0].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {
    "fileUris": ["https://stocsa.blob.core.windows.net/vmaas/windows_common.ps1"],
    "commandToExecute": "${local.win_post_deploy_script_command}"
  }
  SETTINGS
  depends_on         = [azurerm_managed_disk.virtual_machine_data_disk, azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment, null_resource.validation_wallix_ad, null_resource.validation_wallix_ba]
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  count                           = var.os.type != "Windows" ? 1 : 0
  name                            = local.vm_name
  location                        = local.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = ["${azurerm_network_interface.VmNic.id}"]
  size                            = var.size
  admin_username                  = azurerm_key_vault_secret.client_credentials_login.value
  admin_password                  = azurerm_key_vault_secret.client_credentials_password.value
  disable_password_authentication = false
  tags                            = data.azurerm_resource_group.rg_target.tags["app_family"] == "Application" ? { for key, value in local.virtual_machine_tags_cbapp : key => value if value != "" } : local.virtual_machine_tags_cblab
  source_image_id                 = data.azurerm_shared_image.osfactory_image.id
  custom_data                     = local.cloud_init_config

  zone                = var.availability_zone != null && var.availability_zone != "" ? var.availability_zone : null
  availability_set_id = var.availability_zone == "" && var.availability_set_name == "" && var.create_availability_set ? azurerm_availability_set.availabilityset[0].id : length(data.azurerm_availability_set.availability_set) > 0 ? data.azurerm_availability_set.availability_set[0].id : null
  identity {
      type = "SystemAssigned"
  }
  plan {
    name      = var.os.type != "Rocky" ? "" : local.plan_name
    product   = var.os.type != "Rocky" ? "" : local.plan_product
    publisher = var.os.type != "Rocky" ? "" : local.plan_publisher
  }
  os_disk {
    name                 = "${local.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm_sa.primary_blob_endpoint
  }
  depends_on = [null_resource.validation_wallix_ad, null_resource.validation_wallix_ba]
}

resource "azurerm_virtual_machine_extension" "vm_lin_post_deploy_script" {
  count                = var.os.type != "Windows" ? 1 : 0
  name                 = azurerm_linux_virtual_machine.virtual_machine[0].name
  virtual_machine_id   = azurerm_linux_virtual_machine.virtual_machine[0].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  protected_settings = <<PROT

{
  "fileUris": ["https://stocsa.blob.core.windows.net/vmaas/ubuntu_common.sh"],
  "commandToExecute": "bash ubuntu_common.sh ${data.azurerm_resource_group.rg_target.tags["managed_by_capmsp"]}"
}
  PROT
  depends_on         = [azurerm_managed_disk.virtual_machine_data_disk, azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment, azurerm_virtual_machine_extension.vmagentama, null_resource.validation_wallix_ad, null_resource.validation_wallix_ba]
}


resource "azurerm_managed_disk" "virtual_machine_data_disk" {
  for_each             = var.data_disk
  name                 = format("%s-datadisk-%s", "${local.vm_name}", each.value.lun)
  location             = local.location
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.type
  create_option        = "Empty"
  disk_size_gb         = each.value.size
  zone                 = var.availability_zone != null && var.availability_zone != "" ? var.availability_zone : null
  depends_on           = [null_resource.validation_wallix_ad, null_resource.validation_wallix_ba]
}

resource "azurerm_virtual_machine_data_disk_attachment" "virtual_machine_data_disk_attachment" {
  for_each           = var.data_disk
  managed_disk_id    = azurerm_managed_disk.virtual_machine_data_disk[each.key].id
  virtual_machine_id = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  lun                = each.value.lun
  caching            = "ReadWrite"
  depends_on         = [null_resource.validation_wallix_ad, null_resource.validation_wallix_ba]
}
