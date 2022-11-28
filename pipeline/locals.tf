locals {
  storage_account_name = lower("${var.stack_identifier}storageccs")
  resource_group_name  = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  resource_group_id    = data.azurerm_resource_group.current.id
  azure_client_id      = data.terraform_remote_state.auth.outputs.databricks_client_id
  azure_client_secret  = data.terraform_remote_state.auth.outputs.databricks_application_password
  azure_tenant_id      = data.azurerm_client_config.current.tenant_id
}
