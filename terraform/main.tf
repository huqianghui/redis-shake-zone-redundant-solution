resource "azurerm_network_security_group" "res-2" {
  location            = "chinanorth3"
  name                = "redisshakevm-nsg"
  resource_group_name = "redis-shake-test-rg"
  depends_on = [
    azurerm_resource_group.res-24,
  ]
}
resource "azurerm_public_ip" "res-4" {
  allocation_method   = "Static"
  domain_name_label   = null
  location            = "chinanorth3"
  name                = "redis-server-withshake-target02-ip"
  public_ip_prefix_id = null
  resource_group_name = "redis-shake-test-rg"
  reverse_fqdn        = null
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  depends_on = [
    azurerm_resource_group.res-24,
  ]
}
resource "azurerm_lb" "res-19" {
  location            = "chinanorth3"
  name                = "redis-shake-vms-lb"
  resource_group_name = "redis-shake-test-rg"
  sku                 = "Standard"
  frontend_ip_configuration {
    name  = "redis-shake-vms-lb-pip"
    zones = ["1", "2", "3"]
  }
  depends_on = [
    azurerm_subnet.res-18,
    azurerm_lb_backend_address_pool.res-12,
  ]
}
resource "azurerm_network_interface" "res-22" {
  enable_accelerated_networking = true
  location                      = "chinanorth3"
  name                          = "redis-server-with102"
  resource_group_name           = "redis-shake-test-rg"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/publicIPAddresses/redis-server-withshake-target02-ip"
    subnet_id                     = "/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/virtualNetworks/redis-shake-test-rg-vnet/subnets/default"
  }
  depends_on = [
    azurerm_public_ip.res-4,
    azurerm_subnet.res-18,
    azurerm_lb_backend_address_pool.res-12,
    azurerm_lb_backend_address_pool.res-13,
    azurerm_network_security_group.res-1,
  ]
}
resource "azurerm_network_interface" "res-23" {
  enable_accelerated_networking = true
  location                      = "chinanorth3"
  name                          = "redisshakevm878"
  resource_group_name           = "redis-shake-test-rg"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/publicIPAddresses/redisshakevm-ip"
    subnet_id                     = "/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/virtualNetworks/redis-shake-test-rg-vnet/subnets/default"
  }
  depends_on = [
    azurerm_public_ip.res-5,
    azurerm_subnet.res-18,
    azurerm_lb_backend_address_pool.res-12,
    azurerm_lb_backend_address_pool.res-13,
    azurerm_network_security_group.res-2,
  ]
}
resource "azurerm_network_interface" "res-21" {
  enable_accelerated_networking = true
  location                      = "chinanorth3"
  name                          = "redis-server-src-655"
  resource_group_name           = "redis-shake-test-rg"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/publicIPAddresses/redis-server-src-vm-ip"
    subnet_id                     = "/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/virtualNetworks/redis-shake-test-rg-vnet/subnets/default"
  }
  depends_on = [
    azurerm_public_ip.res-3,
    azurerm_subnet.res-18,
    azurerm_network_security_group.res-0,
  ]
}
resource "azurerm_network_security_group" "res-0" {
  location            = "chinanorth3"
  name                = "redis-server-src-vm-nsg"
  resource_group_name = "redis-shake-test-rg"
  depends_on = [
    azurerm_resource_group.res-24,
  ]
}
resource "azurerm_public_ip" "res-3" {
  allocation_method   = "Static"
  domain_name_label   = null
  location            = "chinanorth3"
  name                = "redis-server-src-vm-ip"
  public_ip_prefix_id = null
  resource_group_name = "redis-shake-test-rg"
  reverse_fqdn        = null
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  depends_on = [
    azurerm_resource_group.res-24,
  ]
}
resource "azurerm_public_ip" "res-5" {
  allocation_method   = "Static"
  domain_name_label   = null
  location            = "chinanorth3"
  name                = "redisshakevm-ip"
  public_ip_prefix_id = null
  resource_group_name = "redis-shake-test-rg"
  reverse_fqdn        = null
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  depends_on = [
    azurerm_resource_group.res-24,
  ]
}
resource "azurerm_linux_virtual_machine" "redis-server-src-vm" {
  admin_password                  = null # sensitive
  admin_username                  = "huqianghui"
  custom_data                     = null # sensitive
  disable_password_authentication = false
  location                        = "chinanorth3"
  name                            = "redis-server-src-vm"
  network_interface_ids           = ["/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/networkInterfaces/redis-server-src-655"]
  resource_group_name             = "redis-shake-test-rg"
  size                            = "Standard_E4s_v5"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-confidential-vm-focal"
    publisher = "canonical"
    sku       = "20_04-lts-cvm"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-21,
  ]
}
resource "azurerm_lb_backend_address_pool" "res-12" {
  loadbalancer_id = "/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/loadBalancers/redis-shake-vms-lb"
  name            = "redis-shake-vms-lb-pool"
  depends_on = [
    azurerm_lb.res-19,
  ]
}
resource "azurerm_lb_backend_address_pool" "res-13" {
  loadbalancer_id = "/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/loadBalancers/redis-shake-vm-web-lb"
  name            = "redis-shake-vm-web-lb-pool"
  depends_on = [
    azurerm_lb.res-20,
  ]
}
resource "azurerm_lb" "res-20" {
  location            = "chinanorth3"
  name                = "redis-shake-vm-web-lb"
  resource_group_name = "redis-shake-test-rg"
  sku                 = "Standard"
  frontend_ip_configuration {
    name = "redis-shake-vm-web-lb-pip"
  }
  depends_on = [
    azurerm_public_ip.res-6,
    azurerm_lb_backend_address_pool.res-13,
  ]
}
resource "azurerm_resource_group" "res-24" {
  location = "chinanorth3"
  name     = "redis-shake-test-rg"
}
resource "azurerm_public_ip" "res-6" {
  allocation_method   = "Static"
  domain_name_label   = null
  location            = "chinanorth3"
  name                = "redis-shake-vm-web-lb-ip"
  public_ip_prefix_id = null
  resource_group_name = "redis-shake-test-rg"
  reverse_fqdn        = null
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  depends_on = [
    azurerm_resource_group.res-24,
  ]
}
resource "azurerm_linux_virtual_machine" "redisshakevm" {
  admin_password                  = null # sensitive
  admin_username                  = "huqianghui"
  custom_data                     = null # sensitive
  disable_password_authentication = false
  location                        = "chinanorth3"
  name                            = "redisshakevm"
  network_interface_ids           = ["/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/networkInterfaces/redisshakevm878"]
  resource_group_name             = "redis-shake-test-rg"
  size                            = "Standard_E4s_v5"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "canonical"
    sku       = "20_04-lts"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-23,
  ]
}
resource "azurerm_network_security_rule" "res-14" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = "redis-server-src-vm-nsg"
  priority                    = 300
  protocol                    = "TCP"
  resource_group_name         = "redis-shake-test-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-0,
  ]
}
resource "azurerm_network_security_rule" "res-16" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "6380"
  direction                   = "Inbound"
  name                        = "AllowAnyCustom6380Inbound"
  network_security_group_name = "redisshakevm-nsg"
  priority                    = 310
  protocol                    = "*"
  resource_group_name         = "redis-shake-test-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-2,
  ]
}
resource "azurerm_subnet" "res-18" {
  enforce_private_link_endpoint_network_policies = true
  name                                           = "default"
  resource_group_name                            = "redis-shake-test-rg"
  virtual_network_name                           = "redis-shake-test-rg-vnet"
  depends_on = [
    azurerm_virtual_network.res-7,
  ]
}
resource "azurerm_network_security_group" "res-1" {
  location            = "chinanorth3"
  name                = "redis-server-withshake-target02-nsg"
  resource_group_name = "redis-shake-test-rg"
  depends_on = [
    azurerm_resource_group.res-24,
  ]
}
resource "azurerm_virtual_network" "res-7" {
  address_space       = ["10.2.0.0/16"]
  location            = "chinanorth3"
  name                = "redis-shake-test-rg-vnet"
  resource_group_name = "redis-shake-test-rg"
  depends_on = [
    azurerm_resource_group.res-24,
  ]
}
resource "azurerm_linux_virtual_machine" "redis-server-withshake-target02" {
  admin_password                  = null # sensitive
  admin_username                  = "huqianghui"
  custom_data                     = null # sensitive
  disable_password_authentication = false
  location                        = "chinanorth3"
  name                            = "redis-server-withshake-target02"
  network_interface_ids           = ["/subscriptions/60a43a8b-348b-4e0f-a5d7-eff5f5f72125/resourceGroups/redis-shake-test-rg/providers/Microsoft.Network/networkInterfaces/redis-server-with102"]
  resource_group_name             = "redis-shake-test-rg"
  size                            = "Standard_E4s_v5"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-confidential-vm-focal"
    publisher = "canonical"
    sku       = "20_04-lts-cvm"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-22,
  ]
}
resource "azurerm_network_security_rule" "res-15" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = "redis-server-withshake-target02-nsg"
  priority                    = 300
  protocol                    = "TCP"
  resource_group_name         = "redis-shake-test-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-1,
  ]
}
resource "azurerm_network_security_rule" "res-17" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = "redisshakevm-nsg"
  priority                    = 300
  protocol                    = "TCP"
  resource_group_name         = "redis-shake-test-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-2,
  ]
}