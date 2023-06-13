resource "null_resource" "validation_wallix_ad" {
  count = ((var.wallix_client) && (length(var.wallix_ad_account) == 0) && (var.ad_domain != "workgroup")) ? 1 : 0 
    triggers = {
        count = 1
    }
    provisioner "local-exec" {
        command =  <<EOC
          write-error "wallix_ad_account can't be null or empty if wallix_client is set to true for an AD joined VM"
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
        write-error "wallix_ba_account can't be null or empty if wallix_client is set to true"
        exit(12)
    EOC
    on_failure = fail
  }
}
