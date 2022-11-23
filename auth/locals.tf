locals {
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
}
