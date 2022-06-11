output "Green" {
  value = data.azurerm_public_ip.green_ip.ip_address
}
output "Blue" {
  value = data.azurerm_public_ip.blue_ip.ip_address
}