resource "azuread_application" "databricks-app" {
  display_name = "${local.resource_group_name}-${var.stack_identifier}-databricks-app"
}

resource "azuread_service_principal" "databricks-app" {
  application_id = azuread_application.databricks-app.application_id
}

resource "azuread_service_principal_password" "databricks-app" {
  service_principal_id = azuread_service_principal.databricks-app.id
}


