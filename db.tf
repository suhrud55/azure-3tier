resource "azurerm_network_interface" "db_nic" {
  name                = "db-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "db-ipconfig"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "db_vm" {
  name                  = "db-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.db_nic.id]
  vm_size               = var.db_vm_size

  storage_os_disk {
    name              = "db-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2019-WS2019"
    sku       = "Standard"
    version   = "latest"
  }

  os_profile {
    computer_name  = "dbvm"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {}
}