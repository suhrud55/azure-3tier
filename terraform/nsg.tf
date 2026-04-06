# Resource Group reference
resource "azurerm_resource_group" "rg" {
  name     = "TrainingandPoC"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-3tier"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-3tier"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-3tier"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# SSH rule
resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range            = "*"            # required
  destination_port_range       = "22"           # required
  source_address_prefix        = "*"            # allow any IP
  destination_address_prefix   = "*"            # all VM IPs
  network_security_group_name  = azurerm_network_security_group.nsg.name
  resource_group_name          = azurerm_resource_group.rg.name
}

# HTTP rule (frontend)
resource "azurerm_network_security_rule" "http" {
  name                        = "http"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "80"
  source_address_prefix        = "*"
  destination_address_prefix   = "*"
  network_security_group_name  = azurerm_network_security_group.nsg.name
  resource_group_name          = azurerm_resource_group.rg.name
}

# Custom port for backend (example 5000)
resource "azurerm_network_security_rule" "backend" {
  name                        = "backend"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "5000"
  source_address_prefix        = "*"
  destination_address_prefix   = "*"
  network_security_group_name  = azurerm_network_security_group.nsg.name
  resource_group_name          = azurerm_resource_group.rg.name
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}