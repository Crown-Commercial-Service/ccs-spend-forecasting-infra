resource "azurerm_data_factory" "import_factory" {
  name                = "ccs-import-factory"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

# resource "azurerm_databricks_workspace" "databricks" {
#   name                = "databricks-test"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   sku                 = "standard"

#   tags = {
#     ManagedBy = "Terraform"
#   }
# }
