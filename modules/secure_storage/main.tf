resource "azurerm_storage_account" "account" {
  name                      = var.storage_account_name
  resource_group_name       = var.rg_name
  location                  = var.rg_location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Region      = var.rg_location
    Environment = var.stack_identifier
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_storage_container" "container" {
  count                 = length(var.container_names)
  name                  = var.container_names[count.index]
  storage_account_name  = azurerm_storage_account.account.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "databricks-blob-contributor" {
  count                = length(var.data_contributor_principals)
  scope                = azurerm_storage_account.account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.data_contributor_principals[count.index]
}
