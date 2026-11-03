terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Remote state lives in an Azure Storage account, one state file per environment.
  # Fill in the values with -backend-config at init time; see README.
  backend "azurerm" {}
}

provider "azurerm" {
  subscription_id = var.subscription_id

  # Authenticate with Azure AD instead of storage account keys.
  storage_use_azuread = true

  features {
    key_vault {
      # Never purge a vault on destroy; soft delete keeps it recoverable.
      purge_soft_delete_on_destroy = false
    }
  }
}
