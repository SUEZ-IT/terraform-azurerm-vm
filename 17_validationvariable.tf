resource "null_resource" "validation_wallix_ad" {
  count = var.wallix_client && length(var.wallix_ad_account) == 0 ? 1 : 0 
    triggers = {
        count = 1
    }
    provisioner "local-exec" {
        command =  <<EOC
          echo "validation wallix_ad_account can't be null or empty if wallix client is set to true"
          exit 1
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
        echo "validation wallix_ba_account can't be null or empty if wallix client is set to true"
        exit 1
    EOC
    on_failure = fail
  }
}
