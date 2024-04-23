resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_network_security_group.nsg]
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sub1" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = var.sub1_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.0.0/24"]

}

# resource "azurerm_subnet" "sub2" {
#   depends_on = [azurerm_virtual_network.vnet]

#   name                 = var.sub2_name
#   resource_group_name  = var.rg_name
#   virtual_network_name = var.vnet_name
#   address_prefixes     = ["10.0.2.0/24"]

# }

resource "azurerm_public_ip" "public_ip_1" {
  depends_on          = [azurerm_resource_group.rg]
  name                = var.public_ip1_name
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "public_ip_2" {
  depends_on = [azurerm_resource_group.rg]

  name                = var.public_ip2_name
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
}

# resource "azurerm_subnet_network_security_group_association" "nsg_sub1" {
#   subnet_id                 = azurerm_subnet.sub1.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
# }
# resource "azurerm_subnet_network_security_group_association" "nsg_sub2" {
#   subnet_id                 = azurerm_subnet.sub1.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
# }