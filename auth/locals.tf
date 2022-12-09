locals {
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  app_names = {
    databricks-app = "${local.resource_group_name}-${var.stack_identifier}-databricks-app"
    terraform-app  = "${local.resource_group_name}-${var.stack_identifier}-terraform-app"
  }
}
