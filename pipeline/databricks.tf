resource "azurerm_databricks_workspace" "databricks" {
  name                = "${local.resource_group_name}-${var.stack_identifier}-databricks"
  resource_group_name = local.resource_group_name
  location            = data.terraform_remote_state.bootstrap.outputs.resource_group_location
  sku                 = "standard"
}

data "databricks_node_type" "smallest" {
  local_disk = true
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
}
