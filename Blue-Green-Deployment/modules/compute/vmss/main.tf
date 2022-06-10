locals {
  nic_name = "Server_NIC"
  vm_name  = "webserver"
  vm_size  = "Standard_B1s"
  }

# Virtual Scale Set 
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = local.vm_name
  resource_group_name = var.resource_group_name 
  location            = var.location
  sku                 = local.vm_size
  instances           = 1
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/key.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = local.nic_name
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              =  var.subnet_id
      load_balancer_backend_address_pool_ids = [var.lb_backend_address_pool]
      load_balancer_inbound_nat_rules_ids    = [var.load_balancer_inbound_nat_rules_ids]

    }
  }
   tags = {
    environment = "${terraform.workspace}"
  }

}