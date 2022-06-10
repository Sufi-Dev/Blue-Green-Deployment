locals {
  vnet_name     = "server_vnet"
  vnet_address  = ["10.0.0.0/16"]
  subnet_name   = "server_subnet"

}
resource "azurerm_virtual_network" "server_net" {
  name                = local.vnet_name
  address_space       = local.vnet_address
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "server_subnet" {
  name                 = local.subnet_name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.server_net.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.server_net
  ]
}
