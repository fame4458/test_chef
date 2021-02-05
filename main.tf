terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_virtual_network" "example" {
  name                = "int493-virtual-net"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_subnet" "example" {
  name                 = "default"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/24"]
}
resource "azurerm_public_ip" "example" {
  name                = "int493-publicip"
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"

}

resource "azurerm_network_interface" "example" {
  name                = "lab1-interface"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "ipconf1"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                            = "lab1-vm"
  resource_group_name             = var.resource_group
  location                        = var.location
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  admin_password                  = "@fame0888702122"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

resource "null_resource" "run" {
  connection {
    host = azurerm_public_ip.example.ip_address
    user = "azureuser"
    password = "@fame0888702122"
  }

  provisioner "remote-exec" {
   inline = [
       "sudo apt-get update",
       "sudo apt install nodejs -y",
       "sudo apt install npm -y",
       "sudo apt install git -y",
       "git clone https://github.com/fame4458/test_lab1.git",
       "cd test_lab1",
       "sudo git checkout develop"
       "npm install",
       "sudo mv test.service /lib/systemd/system/",
       "sudo systemctl enable test.service",
       "sudo systemctl start test.service"
   ]
  }
}
