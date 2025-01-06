resource "null_resource" "validation_bastion_ba" {
  count = var.is_accessible_from_bastion && var.bastion_allowed_ba_entities == "" ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'bastion_allowed_ba_entities can't be empty if is_accessible_from_bastion is set to true.' && exit 1"
  }
}

resource "null_resource" "validation_bastion_ad" {
  count = var.is_accessible_from_bastion && var.ad_domain != "workgroup" && var.os.type == "Windows" && var.bastion_allowed_ad_entities == "" && var.bastion_allowed_ad_groups == "" ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'bastion_allowed_ad_entities and bastion_allowed_ad_groups can't be both empty if is_accessible_from_bastion is set to true for an AD joined Windows VM.' && exit 1"
  }
}
