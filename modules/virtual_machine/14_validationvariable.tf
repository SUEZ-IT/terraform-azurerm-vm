locals {
  # Nettoyage des utilisateurs de la variable remote_desktop_readers
  cleaned_readers = [
    for user in split(",", var.remote_desktop_readers) :
    lower(trimspace(user))
    if trimspace(user) != ""
  ]


  cleaned_administrators = [
    for user in split(",", var.remote_desktop_administrators) :
    lower(trimspace(user))
    if trimspace(user) != ""
  ]

  # Définir les préfixes autorisés pour chaque domaine
  valid_prefixes = {
    "fr.green.local" = ["app", "rsn2s"]
    "green.local"    = ["ia", "aa"]
  }

  # Récupérer les préfixes autorisés pour le domaine spécifié
  allowed_prefixes = lookup(local.valid_prefixes, var.ad_domain, [])

  # Trouver les utilisateurs qui ne respectent pas les préfixes autorisés
  invalid_users = [
    for user in local.cleaned_readers :
    user
    if !anytrue([for prefix in local.allowed_prefixes : startswith(user, prefix)])
  ]

  # Vérifier si tous les utilisateurs sont valides
  is_valid_users = length(local.invalid_users) == 0
 


  # Trouver les administrateurs qui ne respectent pas les préfixes autorisés
  invalid_administrators = [
    for user in local.cleaned_administrators :
    user
    if !anytrue([for prefix in local.allowed_prefixes : startswith(user, prefix)])
  ]

  # Vérifier si tous les administrateurs sont valides
  is_valid_administrators = length(local.invalid_administrators) == 0

}


resource "null_resource" "validate_remote_desktop" {
  count = (
    (length(trimspace(var.remote_desktop_readers)) > 0 || length(trimspace(var.remote_desktop_administrators)) > 0)
    && var.os.type == "Windows"
  ) ? 1 : 0

  lifecycle {
    # Precondition pour vérifier que l'OS est Windows
    precondition {
      condition     = var.os.type == "Windows"
      error_message = "The parameters 'remote_desktop_readers' and 'remote_desktop_administrators' can only be used when OS type is Windows."
    }

    # Precondition pour valider les utilisateurs
    precondition {
      condition     = local.is_valid_users
      error_message = "One or more readers in 'remote_desktop_readers' do not follow the allowed prefixes for domain '${var.ad_domain}. Each value must start with 'APP' or 'rsn2s' for fr.green.local domain, 'IA' or 'AA' for green.local domain '. Invalid readers: ${join(", ", local.invalid_users)}"
    }

    # Precondition pour valider les administrateurs
    precondition {
      condition     = local.is_valid_administrators
      error_message = "One or more administrators in 'remote_desktop_administrators' do not follow the allowed prefixes for domain '${var.ad_domain}'. Each value must start with 'APP' or 'rsn2s' for fr.green.local domain, 'IA' or 'AA' for green.local domain. Invalid administrators: ${join(", ", local.invalid_administrators)}"
    }
  }
}


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





