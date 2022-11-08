data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

module "state_blob" {
  source           = "../modules/secure_storage"
  container_name   = "forecasting${var.stack_identifier}tfstate"
  rg_name          = data.azurerm_resource_group.rg.name
  rg_location      = data.azurerm_resource_group.rg.location
  stack_identifier = var.stack_identifier
}
