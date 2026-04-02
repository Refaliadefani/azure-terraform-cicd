# 1. Tentukan Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_msi = true
  subscription_id = "c943efc2-430f-4c7c-a428-293d6fb2c352"
  client_id       = "861650c0-ec32-4ecf-a9af-39ff00274509"
}

# 2. Buat Resource Group (Rumah Infrastruktur)
resource "azurerm_resource_group" "rg" {
  name     = "rg-refa-terraform-cicd"
  location = "Southeast Asia" 
}

# 3. Virtual Network & Subnet (Jalanan Data)
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-refacicd"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# 4. Public IP (Biar bisa diakses dari luar - WAJIB!)
resource "azurerm_public_ip" "pip" {
  name                = "pip-refa"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

}

# 5. Network Security Group (Buka Pintu SSH Port 22)
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-refa"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 6. Network Interface (KTP-nya si VM)
resource "azurerm_network_interface" "nic" {
  name                = "nic-refa"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}
  resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 7. Virtual Machine (Bintang Tamunya!)
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-refa-terraform"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s" # Size paling murah biar gak boncos
  admin_username      = "refatf"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "refatf"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZq6t72xBL2NWZ3UCxbRZ6Kqsp2XDCM3WQM80Fr3NtkQqbXTj6pD+LkctPxnHkemQ6s5JSzCL6bb6yDjp/bKLd2U3NjfCpuLf3Myeq/doaGdYmW7fEqCL0LNxZOijlVFYuhefD+FmkJd4Z4x5DHRciKMaR6yklND4S5PHf0G7lFLpYe9GeEV0LC9mF6IAtW7MYO8PkgqzQl3/6aKbvLeDhsDtXaeQ/Tg7g934LQyaIqYEUhqtGHrAcNpVggTiaHhKUebFyUQOdyCXfqyDf8f3fLRWJZGWBsPLZoKGHKMwdUJya+BPR+IaaIPG5JzQQDT/ZlF/AAPbclqRhbUtLLi+dtFRk8tr91MSxHdP+A9yR4imi14H+HNwSIPrWT9X7SRQm/AszrRH7h7/udYqX5SH9+yjkygeZHKe0hhuvR5Ii4Cl1WYn4YTQ9wSYAWUjwTRQ0PoEu4yTtOp3k52i/W2GFNvFy+WiKFQzwy9YVUzDVL5UyrLQveNzRS3SYJJf4SVrpYHlqgFi/SQBFvgfgY/mr/MbuW7sHpe4ye6QyqYuZYX16tGqTduLk/ktGkVyUk4gEcEhac5XEbXqC2RYis+EZlnGhcQWgBgWziZF75FMnu4nyvAz1KZx1zlpD4u88sx/gRX7UOZOlGgzSGcIprfGHxJwieniCLfer7LT+uof7ww== asus@LAPTOP-9HQTQER3"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
