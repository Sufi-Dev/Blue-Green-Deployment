
# Here I am referencing the green environment virtual scale set IP
data "azurerm_public_ip" "green_ip" {
  name                = "Server_PIP"
  resource_group_name = "Green_RG"
}

# Here I am referencing the blue environment virtual scale set IP
data "azurerm_public_ip" "blue_ip" {
  name                = "Server_PIP"
  resource_group_name = "Blue_RG"
}

locals {
  failover_location = "eastasia"
  db_name           = "cosmosdb698909"
}
# Creating a gateway group name control-RG
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

}

# imported cosmosDB module
module "db" {
   source              = "./modules/storage/cosmosDB"
   location            = var.db_location
   resource_group_name = var.resource_group_name
   failover_location   = local.failover_location
   db_name             = local.db_name
}

module "traffic_manager" {
  source               = "./modules/network/traffic_manager"
  traffic_manager_name = "Azure-Traffic"
  dns_name             = "portfolios"
  resource_group_name  = var.resource_group_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}
resource "azurerm_traffic_manager_azure_endpoint" "green_endpoint" {
  name               = "green-endpoint"
  profile_id         = module.traffic_manager.traffic_profile_id
  target_resource_id = data.azurerm_public_ip.green_ip.id
  weight             = 100
}
resource "azurerm_traffic_manager_azure_endpoint" "blue_endpoint" {
  name               = "blue-endpoint"
  profile_id         = module.traffic_manager.traffic_profile_id
  target_resource_id = data.azurerm_public_ip.blue_ip.id
  weight             = 1
}