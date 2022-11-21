resource "azurerm_resource_group_policy_assignment" "inheritTagFromRG" {
  count                = length(var.mandatory_tag_keys)
  name                 = "inheritTagFromRG_${var.mandatory_tag_keys[count.index]}"
  display_name         = "Inherit tag ${var.mandatory_tag_keys[count.index]} from the resource group"
  resource_group_id    = local.resource_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cd3aa116-8754-49c9-a813-ad46512ece54"
  location             = data.terraform_remote_state.bootstrap.outputs.resource_group_location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMS
      {
        "tagName": {
          "value": "${var.mandatory_tag_keys[count.index]}"
        }
      }
  PARAMS
}

resource "azurerm_role_assignment" "assignment" {
  count                = length(var.mandatory_tag_keys)
  scope                = local.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.inheritTagFromRG[count.index].identity[0].principal_id
}

resource "azurerm_resource_group_policy_remediation" "inheritTagFromRG" {
  count                = length(var.mandatory_tag_keys)
  name                 = "inherit-tag-from-rg-remediation-${lower(var.mandatory_tag_keys[count.index])}"
  resource_group_id    = local.resource_group_id
  policy_assignment_id = azurerm_resource_group_policy_assignment.inheritTagFromRG[count.index].id
}
