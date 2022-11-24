variable "cluster_name" {
  description = "Names of the cluster to create"
  type        = string
}

variable "secret_scope_name" {
  description = "Name to use for the secret scope"
  type        = string
}

variable "python_libraries" {
  description = "List of libraries to install on the cluster"
  type        = list(string)
}

variable "secrets" {
  description = "Map of secrets to add to the cluster"
  type        = map(any)
}

variable "host" {
  type = string
}

variable "azure_workspace_resource_id" {
  type = string
}

variable "azure_client_id" {
  type = string
}

variable "azure_client_secret" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}
