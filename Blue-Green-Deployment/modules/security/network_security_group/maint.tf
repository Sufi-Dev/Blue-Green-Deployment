

locals {
  sg_name = "security_group01"
}
resource "azurerm_network_security_group" "server_sg" {
  name                = local.sg_name
  resource_group_name = var.resource_group_name
  location = var.location
  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

output "sg_id" {
  value = azurerm_network_security_group.server_sg.id
}