output "server_ip" {
  value = azurerm_public_ip.server_pip.ip_address
}
