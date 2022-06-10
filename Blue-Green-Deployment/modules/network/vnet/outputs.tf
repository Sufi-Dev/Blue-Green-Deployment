output "vnet_id" {
 value = azurerm_virtual_network.server_net.id 
}
output "subnet_id" {
 value = azurerm_subnet.server_subnet.id 
}