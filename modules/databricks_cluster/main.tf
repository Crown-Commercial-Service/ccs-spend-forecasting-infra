# Get the smallest node type possible
data "databricks_node_type" "smallest" {
  local_disk = true
  category   = "General Purpose"
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "pipeline_cluster" {
  cluster_name            = var.cluster_name
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
  # Libraries for the spark cluster need to be in one block per package
  # See https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster#library-configuration-block
  dynamic "library" {
    for_each = var.python_libraries
    content {
      pypi {
        package = library.value
      }
    }
  }
}

resource "databricks_secret_scope" "secret" {
  name                     = var.secret_scope_name
  initial_manage_principal = "users"
}

resource "databricks_secret" "secrets" {
  for_each     = var.secrets
  key          = each.key
  string_value = each.value
  scope        = databricks_secret_scope.secret.id
}
