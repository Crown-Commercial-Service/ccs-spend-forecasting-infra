output "application_password" {
  value     = azuread_service_principal_password.databricks-app.value
  sensitive = true
}
