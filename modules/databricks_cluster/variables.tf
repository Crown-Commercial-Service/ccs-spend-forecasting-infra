variable "cluster_name" {
  description = "Names of the cluster to create"
  type        = string
}

variable "secret_scope_name" {
  description = "Name to use for the secret scope"
  type        = string
}

variable "libraries" {
  description = "List of libraries to install on the cluster"
  type        = list(string)
}

variable "secrets" {
  description = "Map of secrets to add to the cluster"
  type        = map(any)
}
