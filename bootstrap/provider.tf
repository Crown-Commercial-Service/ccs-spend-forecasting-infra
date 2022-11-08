terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-ccs-tfstate"
#     storage_account_name = "ccstfstate"
#     container_name       = "tfstate"
#     key                  = "terraform.tfstate"
#   }
# }

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
