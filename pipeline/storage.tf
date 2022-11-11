module "storage_blob" {
  source               = "../modules/secure_storage"
  storage_account_name = local.storage_account_name
  container_names = [
    lower("${local.resource_group_name}-${var.stack_identifier}-raw"),
    lower("${local.resource_group_name}-${var.stack_identifier}-transformed"),
    lower("${local.resource_group_name}-${var.stack_identifier}-analysed")
  ]
  rg_name          = local.resource_group_name
  rg_location      = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  stack_identifier = var.stack_identifier
}
