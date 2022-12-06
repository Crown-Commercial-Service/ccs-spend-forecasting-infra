output "databricks_service_principal_password" {
  value     = module.app-registrations["databricks-app"].service_principal_password
  sensitive = true
}

output "databricks_client_id" {
  value = module.app-registrations["databricks-app"].client_id
}

output "databricks_service_principal_id" {
  value = module.app-registrations["databricks-app"].service_principal_id
}

output "terraform_client_id" {
  value = module.app-registrations["terraform-app"].client_id
}
