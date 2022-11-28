module "app-registrations" {
  for_each     = local.app_names
  source       = "../modules/app_registration"
  display_name = each.value
}

resource "azuread_application_federated_identity_credential" "github" {
  application_object_id = module.app-registrations["github-app"].object_id
  display_name          = "${var.stack_identifier}-github-actions-oidc"
  description           = "Created by Terraform (stack - ${var.stack_identifier}) to authenticate github actions via OIDC"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:Crown-Commercial-Service/ccs-spend-forecasting-app:environment:${var.stack_identifier}"
}

# Provide access to the github app to the resource group
resource "azurerm_role_assignment" "rg_contributor" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.resource_group_name}"
  role_definition_name = "Contributor"
  principal_id         = module.app-registrations["github-app"].service_principal_id
}
