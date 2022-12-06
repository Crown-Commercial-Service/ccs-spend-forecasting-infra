# module "databricks_workspace" {
#   source              = "../modules/databricks_workspace"
#   name                = "${local.resource_group_name}-${var.stack_identifier}-databricks"
#   resource_group_name = local.resource_group_name
# }

resource "azurerm_databricks_workspace" "databricks" {
  name                = "${local.resource_group_name}-${var.stack_identifier}-databricks"
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  location            = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  sku                 = "standard"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "databricks_cluster" {
  source = "../modules/databricks_cluster"
  # Secrets to Authenticate with databricks via service principal
  azure_client_id             = local.azure_client_id
  azure_client_secret         = local.azure_client_secret
  azure_tenant_id             = local.azure_tenant_id
  host                        = azurerm_databricks_workspace.databricks.workspace_url
  azure_workspace_resource_id = azurerm_databricks_workspace.databricks.workspace_id
  cluster_name                = "${local.resource_group_name}-${var.stack_identifier}-cluster"
  secret_scope_name           = "${local.resource_group_name}-${var.stack_identifier}-scope"
  python_libraries = [
    "python-dotenv",
    "azure-identity",
    "azure-storage-blob",
    "ipython",
    "matplotlib"
  ]
  # Secrets to be accessible within databricks cluster
  secrets = {
    application_password = local.azure_client_secret
    client_id            = local.azure_client_id
    tenant_id            = local.azure_tenant_id
  }
}

