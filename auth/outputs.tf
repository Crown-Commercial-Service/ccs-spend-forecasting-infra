output "application_password" {
  value     = module.app-registrations["databricks-app"].application_password
  sensitive = true
}

output "client_id" {
  value = module.app-registrations["databricks-app"].client_id
}

output "github_client_id" {
  value = module.app-registrations["github-app"].client_id
}
