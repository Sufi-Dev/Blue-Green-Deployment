resource "azurerm_traffic_manager_profile" "profile" {
  name                = var.traffic_manager_name
  resource_group_name = var.resource_group_name


  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = var.dns_name
    ttl           = 100
  }

  monitor_config {
    protocol = "HTTP"
    port     = 80
    path     = "/"
  }
}

