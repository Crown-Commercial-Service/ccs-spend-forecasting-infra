resource "azurerm_databricks_workspace" "databricks" {
  name                = var.name
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  location            = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  sku                 = "standard"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
