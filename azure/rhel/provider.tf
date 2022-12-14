terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 1.0"
    }
  }
}

# Azurerm provider configuration
provider "azurerm" {
  features {}
}

