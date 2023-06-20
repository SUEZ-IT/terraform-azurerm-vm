resource "null_resource" "validation_wallix_ad" {
  count = ((var.wallix_client) && (length(var.wallix_ad_account) == 0) && (var.ad_domain != "workgroup")) ? 1 : 0 
    triggers = {
        count = 1
    }
    provisioner "local-exec" {
        command =  <<EOC
          echo "wallix_ad_account can't be null or empty if wallix_client is set to true for an AD joined VM."
          exit 1
          write-error "wallix_ad_account can't be null or empty if wallix_client is set to true for an AD joined VM."
          exit(12)
        EOC
        on_failure = fail
    }
}

resource "null_resource" "validation_wallix_ba" {
  count = var.wallix_client && length(var.wallix_ba_account) == 0 ? 1 : 0 
  triggers = {
    count = 1
  }
  provisioner "local-exec" {
    command =  <<EOC
        echo "wallix_ba_account can't be null or empty if wallix_client is set to true."
        exit 1
        write-error "wallix_ba_account can't be null or empty if wallix_client is set to true."
        exit(12)
    EOC
    on_failure = fail
  }
}
resource "null_resource" "validation_availability_set" {
  count = (var.availability_set_name != "" || var.create_availability_set) && length(var.availability_zone) != 0 ? 1 : 0 
  triggers = {
    count = 1
  }
  provisioner "local-exec" {
    command =  <<EOC
        echo "You can't have an Availability Set to true and an Availability Zone (please choose only one of them)."
        exit 1
        write-error "You can't have an Availability Set to true and an Availability Zone (please choose only one of them)."
        exit(12)
    EOC
    on_failure = fail
  }
}

resource "null_resource" "validation_create_availability_set" {
  count = var.availability_set_name != "" && var.create_availability_set? 1 : 0 
  triggers = {
    count = 1
  }
  provisioner "local-exec" {
    command =  <<EOC
        echo "You can't set variable create_availability_set to true if availability_set_name not is empty."
        exit 1
        write-error "You can't set variable create_availability_set to true if availability_set_name not is empty."
        exit(12)
    EOC
    on_failure = fail
  }
}
