terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-ccs-tfstate"
    storage_account_name = "ccstfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = "ccs-rg"
  location = "uksouth"
}

resource "azurerm_data_factory" "import_factory" {
  name                = "ccs-import-factory"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = "databricks-test"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"

  tags = {
    ManagedBy = "Terraform"
  }
}
