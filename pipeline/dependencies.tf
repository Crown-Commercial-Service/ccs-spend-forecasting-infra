data "terraform_remote_state" "bootstrap" {
  backend = "azurerm"
  config = {
    storage_account_name = "forecastingtfstate"
    container_name       = "tfstate"
    key                  = "bootstrap-ccs-terraform.tfstate"
    resource_group_name  = var.resource_group_name
  }
}

data "terraform_remote_state" "auth" {
  backend = "azurerm"
  config = {
    storage_account_name = "forecastingtfstate"
    container_name       = "tfstate"
    key                  = "auth-${var.stack_identifier}-terraform.tfstate"
    resource_group_name  = var.resource_group_name
  }
}
