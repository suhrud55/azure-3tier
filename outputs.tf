output "web_public_ip" {
  value = azurerm_public_ip.web_ip.ip_address
}

output "app_private_ip" {
  value = azurerm_network_interface.app_nic.ip_configuration[0].private_ip_address
}

output "db_private_ip" {
  value = azurerm_network_interface.db_nic.ip_configuration[0].private_ip_address
}