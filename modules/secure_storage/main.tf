resource "azurerm_storage_account" "account" {
  name                      = var.container_name
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
    Region             = var.rg_location
    Environment        = var.stack_identifier
    MaintenanceWindow  = "Any"
    Department         = "TBC"
    ApplicationName    = "Forecasting"
    TechnicalContact   = "TBC"
    Owner              = "TBC"
    DataClassification = "TBC"
  }
}
