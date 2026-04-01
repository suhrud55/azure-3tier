resource "azurerm_public_ip" "web_ip" {
  name                = "web-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "web_nic" {
  name                = "web-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "web-ipconfig"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_ip.id
  }
}

resource "azurerm_virtual_machine" "web_vm" {
  name                  = "web-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.web_nic.id]
  vm_size               = var.web_vm_size

  storage_os_disk {
    name              = "web-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "webvm"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "null_resource" "web_app_deploy" {
  depends_on = [azurerm_virtual_machine.web_vm]

  connection {
    type     = "ssh"
    host     = azurerm_public_ip.web_ip.ip_address
    user     = var.admin_username
    password = var.admin_password
  }

  provisioner "file" {
    source      = "web_sample_code/"
    destination = "/home/${var.admin_username}/web_app/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3 python3-pip",
      "cd /home/${var.admin_username}/web_app",
      "nohup python3 app.py &"
    ]
  }
}