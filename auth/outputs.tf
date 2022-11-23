output "client_secret" {
  value     = azuread_service_principal_password.databricks-app.value
  sensitive = true
}
