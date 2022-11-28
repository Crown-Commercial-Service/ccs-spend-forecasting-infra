output "application_password" {
  value     = azuread_service_principal_password.app.value
  sensitive = true
}

output "client_id" {
  value = azuread_application.app.application_id
}
