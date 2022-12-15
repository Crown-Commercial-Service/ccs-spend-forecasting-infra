resource "github_repository_environment" "repo_environment" {
  repository  = local.app_repo_name
  environment = "${var.stack_identifier}-terraform"
}

