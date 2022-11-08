data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

module "state_blob" {
  source               = "../modules/secure_storage"
  storage_account_name = "forecastingtfstate"
  container_name       = "tfstate"
  rg_name              = data.azurerm_resource_group.rg.name
  rg_location          = data.azurerm_resource_group.rg.location
  stack_identifier     = "Global"
}
