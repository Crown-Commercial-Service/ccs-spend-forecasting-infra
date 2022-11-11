module "storage_blob" {
  source               = "../modules/secure_storage"
  storage_account_name = local.storage_account_name
  container_name       = lower("${data.terraform_remote_state.bootstrap.outputs.resource_group_name}-${var.stack_identifier}")
  rg_name              = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  rg_location          = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  stack_identifier     = var.stack_identifier
}
