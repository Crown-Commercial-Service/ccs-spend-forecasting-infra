resource "azurerm_data_factory" "import_factory" {
  name                = "${var.stack_identifier}-ccs-import-factory"
  location            = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
}


resource "azurerm_data_factory_linked_service_azure_sql_database" "example" {
  name              = "${var.stack_identifier}-sql-connection"
  data_factory_id   = azurerm_data_factory.import_factory.id
  connection_string = var.db_connection_string
}
