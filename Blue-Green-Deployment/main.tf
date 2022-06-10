locals {
  pip_name = "Server_PIP"
  RG       = lookup(var.resource_group_name, terraform.workspace)
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.RG
  location = var.location
   tags = {
    environment = "${terraform.workspace}"
  }
}


module "vnet" {
  source              = "./modules/network/vnet"
  location            = var.location
  resource_group_name = local.RG
 
  depends_on = [
    azurerm_resource_group.rg
  ]
}

module "security_group" {
  source              = "./modules/security/network_security_group"
  location            = var.location
  resource_group_name = local.RG

  depends_on = [
    azurerm_resource_group.rg
  ]
}
resource "azurerm_subnet_network_security_group_association" "name" {
  subnet_id                 = module.vnet.subnet_id
  network_security_group_id = module.security_group.sg_id
  depends_on = [
    module.security_group,
    module.vnet
  ]
}
resource "azurerm_public_ip" "pip" {
  name                = local.pip_name
  resource_group_name = local.RG
  location            = var.location
  allocation_method   = "Static"
  tags = {
    environment = "${terraform.workspace}"
  }
  depends_on = [
    azurerm_resource_group.rg
  ]

}
resource "azurerm_lb" "lb" {
  resource_group_name = local.RG
  name                = "load-lb"
  location            = var.location
  frontend_ip_configuration {
    name                 = "font-ip"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
   tags = {
    environment = "${terraform.workspace}"
  }
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_public_ip.pip
  ]
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
  depends_on = [
    azurerm_lb.lb
  ]
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = local.RG
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "font-ip"
  depends_on = [
    azurerm_lb.lb
  ]
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "http-probe"
  protocol        = "Http"
  request_path    = "/health"
  port            = 8080
  depends_on = [
    azurerm_lb.lb
  ]
}

# Virtual Scale Set Module
module "vmss" {
  source                              = "./modules/compute/vmss"
  resource_group_name                 = local.RG
  subnet_id                           = module.vnet.subnet_id
  location                            = var.location
  load_balancer_inbound_nat_rules_ids = azurerm_lb_nat_pool.lbnatpool.id
  lb_backend_address_pool             = azurerm_lb_backend_address_pool.bpepool.id
}