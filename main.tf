data "azurerm_subnet" "vmsubnet" {
  resource_group_name  = "rg-infracb-network-${local.location}-${local.environment}"
  virtual_network_name = "vnet-${local.environment}01-${local.location}"
  name                 = "snet-${local.app_name}-${lookup(local.cloudbundle_type, data.azurerm_resource_group.rg_target.tags["cloudbundle_type"])}-${local.environment}"
}

data "azurerm_resource_group" "rg_target" {
  name = var.resource_group_name
}

data "azurerm_shared_image" "osfactory_image" {
  provider            = azurerm.gallery
  name                = local.osfactory_image_name
  gallery_name        = local.gallery_name
  resource_group_name = local.gallery_resource_group_name
}

locals {
  vm_name                     = "${substr(data.azurerm_resource_group.rg_target.tags["environment"], 0, 1)}${data.azurerm_resource_group.rg_target.tags["guid"]}${var.index}"
  environment                 = lower(data.azurerm_resource_group.rg_target.tags["environment"])
  app_name                    = lower(data.azurerm_resource_group.rg_target.tags["app_name"])
  location                    = lower(data.azurerm_resource_group.rg_target.location)
  osfactory_image_name        = var.os_type == "Windows" ? "WindowsServer2019Datacenter" : "UbuntuServer1804"
  gallery_name                = "gal_infra_os_factory"
  gallery_resource_group_name = "rg-infra-compute-gallery-northeurope"
  virtual_machine_tags = {
    role                       = var.role
    environment                = local.environment
    reboot_hebdo               = var.reboot_hebdo
    availability               = var.availability
    classification             = var.classification
    os_type                    = var.os_type
    CloudGuard-FusionInventory = var.tags_cloudguard["fusion_inventory"]
  }
  cloudbundle_type = {
    "Enabled"   = "ce"
    "Optimized" = "co"
  }
}

resource "azurerm_network_interface" "VmNic" {
  name                = "nic-${local.vm_name}"
  location            = local.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "nic-${local.vm_name}-conf"
    subnet_id                     = data.azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
  count                 = var.os_type == "Windows" ? 1 : 0
  name                  = local.vm_name
  location              = local.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = ["${azurerm_network_interface.VmNic.id}"]
  size                  = var.size
  admin_username        = azurerm_key_vault_secret.client_credentials_login.value
  admin_password        = azurerm_key_vault_secret.client_credentials_password.value
  tags                  = local.virtual_machine_tags
  source_image_id       = data.azurerm_shared_image.osfactory_image.id
  os_disk {
    name                 = "${local.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm_sa.primary_blob_endpoint
  }
}

resource "azurerm_virtual_machine_extension" "vm_win_post_deploy_script" {
  count                = var.os_type == "Windows" ? 1 : 0
  name                 = azurerm_windows_virtual_machine.virtual_machine[0].name
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine[0].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {
     "commandToExecute": "powershell -encodedCommand ${textencodebase64(file("${path.module}/scripts/vm_win_mount_vol.ps1"), "UTF-16LE")}"
  }
  SETTINGS
  depends_on         = [azurerm_managed_disk.virtual_machine_data_disk, azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment]
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  count                           = var.os_type == "Linux" ? 1 : 0
  name                            = local.vm_name
  location                        = local.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = ["${azurerm_network_interface.VmNic.id}"]
  size                            = var.size
  admin_username                  = azurerm_key_vault_secret.client_credentials_login.value
  admin_password                  = azurerm_key_vault_secret.client_credentials_password.value
  disable_password_authentication = false
  tags                            = local.virtual_machine_tags
  source_image_id                 = data.azurerm_shared_image.osfactory_image.id
  os_disk {
    name                 = "${local.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm_sa.primary_blob_endpoint
  }
}

resource "azurerm_virtual_machine_extension" "vm_lin_post_deploy_script" {
  count                = var.os_type == "Linux" ? 1 : 0
  name                 = azurerm_linux_virtual_machine.virtual_machine[0].name
  virtual_machine_id   = azurerm_linux_virtual_machine.virtual_machine[0].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  protected_settings = <<PROT
  {
     "script": "${base64encode(file("${path.module}/scripts/vm_lin_mount_vol.sh"))}"
  }
  PROT
  depends_on         = [azurerm_managed_disk.virtual_machine_data_disk, azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment]
}

resource "azurerm_managed_disk" "virtual_machine_data_disk" {
  for_each             = var.data_disk
  name                 = format("%s-datadisk-%s", "${local.vm_name}", each.value.lun)
  location             = local.location
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.type
  create_option        = "Empty"
  disk_size_gb         = each.value.size
}

resource "azurerm_virtual_machine_data_disk_attachment" "virtual_machine_data_disk_attachment" {
  for_each           = var.data_disk
  managed_disk_id    = azurerm_managed_disk.virtual_machine_data_disk[each.key].id
  virtual_machine_id = var.os_type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  lun                = each.value.lun
  caching            = "ReadWrite"
}
