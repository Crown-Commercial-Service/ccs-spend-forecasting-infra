terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
  backend "azurerm" {}
}

provider "github" {
  token = var.github_token
  owner = "Crown-Commercial-Service"
}
