variable "stack_identifier" {}

variable "resource_group_name" {}

variable "db_connection_string" {}

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
