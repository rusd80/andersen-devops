
resource "azurerm_storage_account" "myacc" {
  name                     = "examplestoracc8011"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "mycont" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.myacc.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "myblob" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.myacc.name
  storage_container_name = azurerm_storage_container.mycont.name
  type                   = "Block"
  source                 = "index.html"
}
