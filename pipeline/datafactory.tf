resource "azurerm_data_factory" "import_factory" {
  name                = "${var.stack_identifier}-ccs-import-factory"
  location            = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      # permission inconsistancy between CLI and GUI means that we need to ignore this block
      # see https://github.com/integrations/terraform-provider-github/issues/392
      github_configuration,
      tags
    ]
  }
}

resource "azurerm_data_factory_linked_service_azure_sql_database" "sql-connection" {
  name              = "${var.stack_identifier}-sql-connection"
  data_factory_id   = azurerm_data_factory.import_factory.id
  connection_string = var.db_connection_string
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "blob-connection" {
  name                 = "${var.stack_identifier}-storage-connection"
  data_factory_id      = azurerm_data_factory.import_factory.id
  service_endpoint     = "https://${local.storage_account_name}.blob.core.windows.net"
  use_managed_identity = true
}
