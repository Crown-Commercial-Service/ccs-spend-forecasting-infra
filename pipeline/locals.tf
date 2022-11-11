locals {
  storage_account_name = lower("${var.stack_identifier}storageccs")
  resource_group_name  = data.terraform_remote_state.bootstrap.outputs.resource_group_name
}
