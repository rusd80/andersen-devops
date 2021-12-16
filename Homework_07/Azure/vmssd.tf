
resource "azurerm_virtual_machine_scale_set" "example" {
  name                = "mytestscaleset-1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  zones = [1,2]

  #automatic_os_upgrade = true
  upgrade_policy_mode  = "Manual"


  sku {
    name     = "Standard_B1s"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"

  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 2
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
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.backend.id
      application_gateway_backend_address_pool_ids = "${azurerm_application_gateway.network.backend_address_pool[*].id}"

    }
  }


}
output "backend_address_pool" {
    value = "${azurerm_application_gateway.network.backend_address_pool[*].id}"
}