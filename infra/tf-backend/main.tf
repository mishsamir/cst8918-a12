terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_id" "tf" {
  byte_length = 8
}

resource "azurerm_resource_group" "tf" {
  name     = "rg-tfstate"
  location = "East US"

  tags = {
    Environment = "Backend"
    Purpose     = "TerraformState"
  }
}

resource "azurerm_storage_account" "tf" {
  name                     = "tfstate${random_id.tf.hex}"
  resource_group_name      = azurerm_resource_group.tf.name
  location                = azurerm_resource_group.tf.location
  account_tier            = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "Backend"
    Purpose     = "TerraformState"
  }
}

resource "azurerm_storage_container" "tf" {
  name                  = "tfstate"
  storage_account_name = azurerm_storage_account.tf.name
  container_access_type = "private"
}

output "storage_account_name" {
  value = azurerm_storage_account.tf.name
}

output "container_name" {
  value = azurerm_storage_container.tf.name
}

output "resource_group_name" {
  value = azurerm_resource_group.tf.name
}
