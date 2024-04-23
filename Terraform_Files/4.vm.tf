resource "azurerm_network_interface" "nic1" {
  name                = var.nic1_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "my_nic1_configuration"
    subnet_id                     = azurerm_subnet.sub1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_1.id
  }
}

resource "azurerm_network_interface_security_group_association" "nsg-nic1" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}



resource "azurerm_network_interface" "nic2" {
  name                = var.nic2_name
  location            = var.location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "my_nic2_configuration"
    subnet_id                     = azurerm_subnet.sub1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_2.id
  }
}
resource "azurerm_network_interface_security_group_association" "nsg-nic2" {
  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "azurerm_linux_virtual_machine" "jenkins_vm" {
  name                = var.jenkins_vm_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]
  custom_data = base64encode("./jenkins.sh")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    # offer     = "0001-com-ubuntu-server-jammy-daily"
    # publisher = "Canonical"
    # sku       = "22_04-daily-lts-gen2"
    version   = "latest"
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
  }
}

resource "azurerm_linux_virtual_machine" "node_vm" {
  name                = var.node_vm_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic2.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  custom_data = base64encode("./node.sh")
  source_image_reference {
    version   = "latest"
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
  }
}