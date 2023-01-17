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
    "matplotlib",
    "sqlalchemy",
    # for prophet and statsmodels, 
    # specify a minimal version to avoid a dependency conflict with the default numpy & scipy installed in databricks.
    "prophet>=1.1.1",
    "statsmodels>=0.13.5"
  ]
  # Secrets to be accessible within databricks cluster
  secrets = {
    application_password = local.azure_client_secret
    client_id            = local.azure_client_id
    tenant_id            = local.azure_tenant_id
  }
  # depends_on is required as the workspace needs to be created before the
  # provider configuration block is created
  depends_on = [
    azurerm_databricks_workspace.databricks
  ]
}

resource "azurerm_role_assignment" "adf-databricks" {
  scope                = azurerm_databricks_workspace.databricks.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.import_factory.identity[0].principal_id
}

