# Create lab environment for Configure an Azure Load Balancer
# Creates 2 VMs in an Availability Set w/ Virtual Network
# Updated - Bootstrapping OS with IIS
# Needed - Azure Bastion & Subnet
#        - Change to using Public Website
  
# Variables - Providers - Resources Declarations  
  provider "azurerm" {
    features {}
  }

  variable "resource_group_name" {
    default = "azlbrg2"
  }

  variable "location" {
    default = "eastus"
  }
  
  variable "tags" {
   description = "A map of the tags to use for the resources that are deployed"
   type        = map(string)
  
   default = {
     environment = "cloudlab"
   }
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
  
# Add Network Security Group for HTTP
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
# Create Network interfaces - 3
  resource "azurerm_network_interface" "azlbni01" {
    name                        = "azlbni01"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "azlbni01"
        subnet_id                     = azurerm_subnet.azlblab.id
        private_ip_address_allocation = "Dynamic"
    }

  }

  resource "azurerm_network_interface" "azlbni02" {
    name                        = "azlbni02"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "azlbni02"
        subnet_id                     = azurerm_subnet.azlblab.id
        private_ip_address_allocation = "Dynamic"
    }

  }

    resource "azurerm_network_interface" "azlbni03" {
    name                        = "azlbni03"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "azlbni03"
        subnet_id                     = azurerm_subnet.azlblab.id
        private_ip_address_allocation = "Dynamic"
    }

  }
# Associate network security group to subnet
resource "azurerm_subnet_network_security_group_association" "azlblab" {
  subnet_id                 = azurerm_subnet.azlblab.id
  network_security_group_id = azurerm_network_security_group.azlblab.id
}
  
# Create Virtual Machines - 3
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
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }

  resource "azurerm_virtual_machine" "azlbvm02" {
   name                  = "web-02"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.azlbni02.id]
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
     name              = "myosdisk02"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "web-02"
     admin_username = "azlblabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }

    resource "azurerm_virtual_machine" "azlbvm03" {
   name                  = "web-03"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.azlbni03.id]
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
     name              = "myosdisk03"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "web-03"
     admin_username = "azlblabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }
  
  } 


# Virtual Machine Extension to Install IIS
# https://medium.com/@gmusumeci/how-to-bootstrapping-azure-vms-with-terraform-c8fdaa457836#:~:text=+How+to+Bootstrapping+Linux+%26+Windows+Azure,the+Network%0AIn+this+step%2C+we+will...+More+
  
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
            "commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
        }
    SETTINGS
  tags = {

  }
}

resource "azurerm_virtual_machine_extension" "iis-vm-ext-02" {
  #depends_on=[azurerm_windows_virtual_machine.azlbvm]
  count = 1
  name = "iis-vm-ext-02"
  virtual_machine_id = azurerm_virtual_machine.azlbvm02.id
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.9"
  
  # Add code for IIS build out

        settings = <<SETTINGS
        {
            "commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
        }
    SETTINGS
  tags = {

  }
}

resource "azurerm_virtual_machine_extension" "iis-vm-ext-03" {
  #depends_on=[azurerm_windows_virtual_machine.azlbvm]
  count = 1
  name = "iis-vm-ext-03"
  virtual_machine_id = azurerm_virtual_machine.azlbvm03.id
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.9"
  
  # Add code for IIS build out

        settings = <<SETTINGS
        {
            "commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
        }
    SETTINGS
  tags = {

  }
}

resource "azurerm_network_watcher" "azlblab" {
  name                = "azlb-nwwatcher"
  location            = var.location
  resource_group_name = var.resource_group_name
}