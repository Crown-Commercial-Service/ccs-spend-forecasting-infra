output "application_password" {
  value     = azuread_service_principal_password.databricks-app.value
  sensitive = true
}

output "client_id" {
  value = azuread_application.databricks-app.application_id
}
