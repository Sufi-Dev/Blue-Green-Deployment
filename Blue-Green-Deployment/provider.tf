terraform {
   backend "azurerm" {
    resource_group_name  = "RG_TF"
    storage_account_name = "storage01"
    container_name       = "terraform-container"
    key                  = "dev.terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # version = "=3.0.0"
    }
  }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret


  features {}
}
