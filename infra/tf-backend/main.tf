resource "azurerm_resource_group" "tf" {
  name     = "rg-tfstate"
  location = "East US"
}

resource "azurerm_storage_account" "tf" {
  name                     = "tfstate<randomid>"
  resource_group_name      = azurerm_resource_group.tf.name
  location                = azurerm_resource_group.tf.location
  account_tier            = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tf" {
  name                  = "tfstate"
  storage_account_name = azurerm_storage_account.tf.name
  container_access_type = "private"
}
