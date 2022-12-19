resource "github_repository_environment" "repo_environment" {
  repository  = local.app_repo_name
  environment = var.stack_identifier
}

resource "github_actions_environment_secret" "secrets" {
  for_each = {
    AZURE_CLIENT_ID       = data.terraform_remote_state.auth.outputs.databricks_client_id
    AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
    AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
    DATABRICKS_HOSTNAME   = "https://${data.terraform_remote_state.pipeline.outputs.azure_workspace_resource_url}"
  }
  repository      = local.app_repo_name
  environment     = github_repository_environment.repo_environment.environment
  secret_name     = each.key
  plaintext_value = each.value
}
