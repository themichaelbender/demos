# Create lab environment for Configure an Azure Load Balancer
# Creates 2 VMs in an Availability Set w/ Virtual Network
# Updated - Bootstrapping OS with IIS
# Needed - Azure Bastion & Subnet
#        - Change to using Public Website
provider "azurerm" {
    features {}
  }

# Variables & Resources

  variable "resource_group_name" {
    default = "az"
  }
  variable "location" {
    default = "eastus"
  }

# Create virtual network and subnets
  
  resource "azurerm_virtual_network" "azlblab" {
   name                = "azlbvn"
   address_space       = ["10.0.0.0/16"]
   location            = var.location
   resource_group_name = var.resource_group_name
  }
  
  resource "azurerm_subnet" "azlblab" {
   name                 = "azlbsub"
   resource_group_name  = var.resource_group_name
   virtual_network_name = azurerm_virtual_network.azlblab.name
   address_prefixes      = ["10.0.1.0/24"]
  }

# Public IP Address

resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP"
    location                     = "eastus"
    resource_group_name          = var.resource_group_name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

# Add Network Security Group
  resource "azurerm_network_security_group" "azlblab" {
    name                = "azlbnsg"
    location            = "eastus"
    resource_group_name = var.resource_group_name
    
    security_rule {
        name                       = "HTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}
# Create Network interfaces
  resource "azurerm_network_interface" "azlbni01" {
    name                        = "azlbni01"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "azlbni01"
        subnet_id                     = azurerm_subnet.azlblab.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

  }

# Associate network security group to subnet
resource "azurerm_subnet_network_security_group_association" "azlblab" {
  subnet_id                 = azurerm_subnet.azlblab.id
  network_security_group_id = azurerm_network_security_group.azlblab.id
}
  
# Create Virtual Machines
  resource "azurerm_virtual_machine" "azlbvm01" {
   name                  = "web-01"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.azlbni01.id]
   vm_size               = "Standard_B1ms"
   delete_os_disk_on_termination = true
   delete_data_disks_on_termination = true
  
   storage_image_reference {
     publisher = "MicrosoftWindowsServer"
     offer     = "WindowsServer"
     sku       = "2019-Datacenter-Core"
     version   = "latest"
   }
  
   storage_os_disk {
     name              = "myosdisk01"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "web-01"
     admin_username = "azlblabadmin"
     admin_password = "Password1234!"
     # custom_data = file("${path.module}/init.ps1")
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }

# Customize VM
# Ref - https://docs.microsoft.com/en-us/azure/application-gateway/create-url-route-portal

resource "azurerm_virtual_machine_extension" "iis-vm-ext-01" {
  #depends_on=[azurerm_windows_virtual_machine.azlbvm]
  count = 1
  name = "iis-vm-ext-01"
  virtual_machine_id = azurerm_virtual_machine.azlbvm01.id
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.9"
  
  # Add code for IIS build out

        settings = <<SETTINGS
        {
          "FileURIs": [
              "https://raw.githubusercontent.com/themichaelbender/demos/master/terraform/azlb/iis-bootstrap.ps1"
          ],
           "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file iis-bootstrap.ps1"
           
           }
    SETTINGS
  tags = {

  }
}