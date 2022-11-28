output "application_password" {
  value     = azuread_service_principal_password.app.value
  sensitive = true
}

output "client_id" {
  value       = azuread_application.app.application_id
  description = "Client, also known as application, ID"
}

output "object_id" {
  value       = azuread_application.app.object_id
  description = "Internal object id of the application"
}

output "service_principal_id" {
  value = azuread_service_principal.app.id
}
