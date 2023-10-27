resource "azurerm_network_interface" "nic" {
  name                = "nic-${local.vm_name}"
  location            = local.location
  resource_group_name = var.cloudbundle_info.name
  ip_configuration {
    name                          = "nic-${local.vm_name}-conf"
    subnet_id                     = data.azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [null_resource.validation_bastion_ad, null_resource.validation_bastion_ba]
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
  count                 = var.os.type == "Windows" ? 1 : 0
  name                  = local.vm_name
  location              = local.location
  resource_group_name   = var.cloudbundle_info.name
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  size                  = var.size
  admin_username        = azurerm_key_vault_secret.client_credentials_login.value
  admin_password        = azurerm_key_vault_secret.client_credentials_password.value
  tags                  = var.cloudbundle_info.tags["app_family"] == "Application" ? { for key, value in local.virtual_machine_tags_cbapp : key => value if value != "" } : local.virtual_machine_tags_cblab
  source_image_id       = data.azurerm_shared_image.osfactory_image.id
  custom_data           = filebase64(data.archive_file.win_post_deploy_scripts_zipped[0].output_path)
  patch_mode            = "AutomaticByOS"
  zone                  = var.availability_zone != null && var.availability_zone != "" ? var.availability_zone : null
  availability_set_id   = try(var.availability_set_id, null)

  identity {
    type = "SystemAssigned"
  }
  os_disk {
    name                 = "${local.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }
  boot_diagnostics {
    storage_account_uri = null
  }
  depends_on = [null_resource.validation_bastion_ad, null_resource.validation_bastion_ba]
}

resource "azurerm_virtual_machine_extension" "vm_win_post_deploy_script" {
  count                = var.os.type == "Windows" ? 1 : 0
  name                 = azurerm_windows_virtual_machine.virtual_machine[0].name
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine[0].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  protected_settings   = <<SETTINGS
  {
    "commandToExecute": "${local.win_post_deploy_script_command}"
  }
  SETTINGS
  timeouts {
    create = "60m"
    delete = "60m"
  }
  depends_on           = [azurerm_managed_disk.virtual_machine_data_disk, azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment, null_resource.validation_bastion_ad, null_resource.validation_bastion_ba]
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  count                           = var.os.type != "Windows" ? 1 : 0
  name                            = local.vm_name
  location                        = local.location
  resource_group_name             = var.cloudbundle_info.name
  network_interface_ids           = ["${azurerm_network_interface.nic.id}"]
  size                            = var.size
  admin_username                  = azurerm_key_vault_secret.client_credentials_login.value
  admin_password                  = azurerm_key_vault_secret.client_credentials_password.value
  disable_password_authentication = false
  tags                            = var.cloudbundle_info.tags["app_family"] == "Application" ? { for key, value in local.virtual_machine_tags_cbapp : key => value if value != "" } : local.virtual_machine_tags_cblab
  source_image_id                 = data.azurerm_shared_image.osfactory_image.id
  custom_data                     = local.cloud_init_config

  zone                = var.availability_zone != null && var.availability_zone != "" ? var.availability_zone : null
  availability_set_id = try(var.availability_set_id, null)
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
    storage_account_uri = null
  }
  depends_on = [null_resource.validation_bastion_ad, null_resource.validation_bastion_ba]
}

resource "azurerm_managed_disk" "virtual_machine_data_disk" {
  for_each             = var.data_disk
  name                 = format("%s-datadisk-%s", "${local.vm_name}", each.value.lun)
  location             = local.location
  resource_group_name  = var.cloudbundle_info.name
  storage_account_type = each.value.type
  create_option        = "Empty"
  disk_size_gb         = each.value.size
  zone                 = var.availability_zone != null && var.availability_zone != "" ? var.availability_zone : null
  depends_on           = [null_resource.validation_bastion_ad, null_resource.validation_bastion_ba]
}

resource "azurerm_virtual_machine_data_disk_attachment" "virtual_machine_data_disk_attachment" {
  for_each           = var.data_disk
  managed_disk_id    = azurerm_managed_disk.virtual_machine_data_disk[each.key].id
  virtual_machine_id = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  lun                = each.value.lun
  caching            = "ReadWrite"
  depends_on         = [null_resource.validation_bastion_ad, null_resource.validation_bastion_ba]
}
