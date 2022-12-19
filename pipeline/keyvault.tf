resource "azurerm_key_vault" "vault" {
  name                = "replacement-${var.stack_identifier}"
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  location            = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

resource "azurerm_key_vault_access_policy" "vault" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_data_factory.import_factory.identity[0].principal_id

  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault_access_policy" "mt" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.user_group_id

  secret_permissions = [
    "Get", "List", "Purge", "Set", "Recover", "Delete"
  ]
}

resource "azurerm_key_vault_secret" "db-connection-string" {
  name         = "db-connection-string"
  value        = var.db_connection_string
  key_vault_id = azurerm_key_vault.vault.id
  depends_on = [
    azurerm_key_vault_access_policy.mt
  ]
}
