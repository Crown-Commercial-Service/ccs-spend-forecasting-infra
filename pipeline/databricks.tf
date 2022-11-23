resource "azurerm_databricks_workspace" "databricks" {
  name                = "${local.resource_group_name}-${var.stack_identifier}-databricks"
  resource_group_name = local.resource_group_name
  location            = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  sku                 = "standard"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "databricks_cluster" {
  source            = "../modules/databricks_cluster"
  cluster_name      = "${local.resource_group_name}-${var.stack_identifier}-cluster"
  secret_scope_name = "${local.resource_group_name}-${var.stack_identifier}-scope"
  libraries = [
    "python-dotenv",
    "azure-identity",
    "azure-storage-blob"
  ]
  secrets = {
    application_password = data.terraform_remote_state.auth.outputs.application_password
    client_id            = data.terraform_remote_state.auth.outputs.client_id
    tenant_id            = data.azurerm_client_config.current.tenant_id
  }
}

