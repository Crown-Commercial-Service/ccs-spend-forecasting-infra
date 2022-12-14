variable "container_names" {
  description = "Names of containers"
  type        = list(string)
}

variable "storage_account_name" {
  description = "Name of storage account"
}

variable "rg_name" {
  description = "Resource group name"
}

variable "rg_location" {
  description = "Resource group location"
}

variable "stack_identifier" {
  description = "Stack identifier for this resource"
}

variable "data_contributor_principals" {
  description = "List of principals which can access this blob as Storage Blob Data Contributor"
}
