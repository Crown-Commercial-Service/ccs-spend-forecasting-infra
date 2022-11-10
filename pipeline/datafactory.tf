resource "azurerm_data_factory" "import_factory" {
  name                = "${var.stack_identifier}-ccs-import-factory"
  location            = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_data_factory_linked_service_azure_sql_database" "example" {
  name              = "${var.stack_identifier}-sql-connection"
  data_factory_id   = azurerm_data_factory.import_factory.id
  connection_string = var.db_connection_string
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "example" {
  name                 = "${var.stack_identifier}-storage-connection"
  data_factory_id      = azurerm_data_factory.import_factory.id
  service_endpoint     = "https://${local.storage_account_name}.blob.core.windows.net"
  use_managed_identity = true
}


resource "azurerm_role_assignment" "example" {
  scope                = module.storage_blob.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.import_factory.identity[0].principal_id
}
