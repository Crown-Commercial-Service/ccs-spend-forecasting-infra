resource "azurerm_storage_account" "account" {
  name                             = "storageaccountname"
  resource_group_name              = var.rg_name
  location                         = var.rg_location
  account_tier                     = "Standard"
  account_replication_type         = "GRS"
  cross_tenant_replication_enabled = false
  enable_https_traffic_only        = true
  min_tls_version                  = 1.2

  tags = {
    environment = "staging"
  }
}
