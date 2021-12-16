/*
resource "azurerm_storage_account" "storage_acc" {
  name                     = "accsarusd8011"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = "northeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "storage_cont" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.storage_acc.name
  container_access_type = "private"
}

resource "azurerm_virtual_machine_scale_set" "example" {
  name                = "mytestscaleset-1"
  location            = "northeurope"
  resource_group_name = azurerm_resource_group.main.name
  upgrade_policy_mode = "Manual"
  #zones = [1, 2]

  sku {
    name     = "Standard_B1s"
    tier     = "Standard"
    capacity = 2
  }

  os_profile {
    computer_name_prefix = "testvm"
    admin_username       = "myadmin"
    custom_data = base64encode(file("script.sh"))
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/myadmin/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  network_profile {
    name    = "TestNetworkProfile"
    primary = true

    ip_configuration {
      name      = "TestIPConfiguration"
      primary   = true
      subnet_id = azurerm_subnet.backend.id
      application_gateway_backend_address_pool_ids = "${azurerm_application_gateway.network.backend_address_pool[*].id}"
    }
  }

  storage_profile_os_disk {
    name           = "osDiskProfile"
    caching        = "ReadWrite"
    create_option  = "FromImage"
    vhd_containers = ["${azurerm_storage_account.storage_acc.primary_blob_endpoint}${azurerm_storage_container.storage_cont.name}"]
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}


output "backend_address_pool" {
    value = "${azurerm_application_gateway.network.backend_address_pool[*].id}"
}

*/