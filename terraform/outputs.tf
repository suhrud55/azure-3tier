output "web_public_ip" {
  value = azurerm_public_ip.web_ip.ip_address
}

output "app_private_ip" {
  value = azurerm_network_interface.app_nic.private_ip_address
}

output "db_private_ip" {
  value = azurerm_network_interface.db_nic.private_ip_address
}