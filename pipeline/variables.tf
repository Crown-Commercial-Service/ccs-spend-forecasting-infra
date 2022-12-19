variable "stack_identifier" {}

variable "resource_group_name" {}

variable "db_connection_string" {}

variable "github_token" {}

variable "mandatory_tag_keys" {
  type        = list(any)
  description = "List of mandatory tag keys used by policy 'inheritTagFromRG'"
  default = [
    "MaintenanceWindow",
    "Department",
    "ApplicationName",
    "Cost Centre",
    "TechnicalContact",
    "Owner",
    "Data Classification",
  ]
}

variable "user_group_id" {
  description = "Azure AD object representing a group which will have access to Azure keyvault"
}
