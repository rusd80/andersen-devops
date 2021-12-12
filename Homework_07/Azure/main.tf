terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.89.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "673df29e-c2cb-48fe-b265-ff46e2beb987"
  client_id       = "1eac6395-f86f-4d8a-9743-3016409cdae0"
  client_secret   = "V_o7Q~1gLHLid6chHX8UqHnIcWwTu3ECuw04~"
  tenant_id       = "4e20d950-8ef9-4e7f-9688-742e05a2e234"
}

# Create a resource group
resource "azurerm_resource_group" "res-group" {
  name     = "resources-for-homework"
  location = "North Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "my-network" {
  name                = "network-for-homework"
  resource_group_name = azurerm_resource_group.res-group.name
  location            = azurerm_resource_group.res-group.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_network_security_group" "web-network-security-group" {
    name                = "homework-security-group"
    location            = "North Europe"
    resource_group_name = azurerm_resource_group.res-group.name
    security_rule {
        name                       = "HTTP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
      security_rule {
        name                       = "HTTPS"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "SSH"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}
resource "azurerm_subnet" "subnet-A" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.res-group.name
  virtual_network_name = azurerm_virtual_network.my-network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet-B" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.res-group.name
  virtual_network_name = azurerm_virtual_network.my-network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "my-ip" {
  name                = "example-pip"
  resource_group_name = azurerm_resource_group.res-group.name
  location            = azurerm_resource_group.res-group.location
  allocation_method   = "Dynamic"
}