resource "azapi_update_resource" "vm_update" {
  count       = (local.app_family == "lab") ? 1 : 0
  type        = "Microsoft.Compute/virtualMachines@2023-03-01"
  resource_id = local.actual_virtual_machine.id

  body = jsonencode({
    properties = {
      osProfile = {
        windowsConfiguration = (var.os.type == "Windows") ? local.update_management_configuration : null
        linuxConfiguration   = (var.os.type != "Windows") ? local.update_management_configuration : null
      }
    }
  })

}

resource "azurerm_maintenance_configuration" "vm_maintenance_configuration" {
  count                    = (local.app_family == "lab") ? 1 : 0
  name                     = "${local.actual_virtual_machine.name}-mc"
  resource_group_name      = var.cloudbundle_info.name
  location                 = var.cloudbundle_info.location
  scope                    = "InGuestPatch"
  in_guest_user_patch_mode = "User"

  window {
    start_date_time = formatdate("YYYY-MM-DD 00:00", timeadd(timestamp(), "24h"))
    time_zone       = "UTC"
    recur_every     = "Day"
  }

  install_patches {
    dynamic "linux" {
      for_each = var.os.type != "Windows" ? [1] : []
      content {
        classifications_to_include = ["Critical", "Security", "Other"]
      }
    }

    dynamic "windows" {
      for_each = var.os.type == "Windows" ? [1] : []
      content {
        classifications_to_include = ["Critical", "Security", "Updates"]
      }
    }

    reboot = "IfRequired"
  }
}

resource "azurerm_maintenance_assignment_virtual_machine" "vm_maintenance_assignment" {
  count                        = (local.app_family == "lab") ? 1 : 0
  location                     = var.cloudbundle_info.location
  maintenance_configuration_id = azurerm_maintenance_configuration.vm_maintenance_configuration[0].id
  virtual_machine_id           = azapi_update_resource.vm_update[0].id
}