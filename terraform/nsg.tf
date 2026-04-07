

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-3tier"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
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
  resource_group_name          = data.azurerm_resource_group.rg.name
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
  resource_group_name          = data.azurerm_resource_group.rg.name
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
  resource_group_name          = data.azurerm_resource_group.rg.name
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}