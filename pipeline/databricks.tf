resource "azurerm_databricks_workspace" "databricks" {
  name                = "${local.resource_group_name}-${var.stack_identifier}-databricks"
  resource_group_name = local.resource_group_name
  location            = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  sku                 = "standard"
}

data "databricks_node_type" "smallest" {
  local_disk = true
  category   = "General Purpose"
}

output "selected_node_type" {
  value = data.databricks_node_type.smallest.id
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = "${local.resource_group_name}-${var.stack_identifier}-cluster"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  num_workers             = 0
  spark_conf = {
    # Single-node
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.master" : "local[*]"
  }

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }
}

resource "databricks_secret_scope" "secret" {
  name                     = "${local.resource_group_name}-${var.stack_identifier}-scope"
  initial_manage_principal = "users"
}

resource "databricks_secret" "application_password" {
  key          = "application_password"
  string_value = data.terraform_remote_state.auth.outputs.application_password
  scope        = databricks_secret_scope.secret.id
}
