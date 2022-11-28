locals {
  app_names = {
    databricks-app = "${local.resource_group_name}-${var.stack_identifier}-databricks-app"
    github-app     = "${local.resource_group_name}-${var.stack_identifier}-github-app"
  }
}

module "app-registrations" {
  for_each     = local.app_names
  source       = "../modules/app_registration"
  display_name = each.value
}
