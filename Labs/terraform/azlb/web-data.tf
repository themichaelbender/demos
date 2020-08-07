# Create lab environment for Configure an Azure Load Balancer
# Creates a web tier w/ 3 VMs (Web01-03)
# And a data tier w/ 2 VMs (Data01-02)
# Both tiers include subnet and NSG
# All VMs are bootstrapped with IIS and custom webpage w/ name
# Updates 05-08-2020 - Modifed
# Variables - Providers - Resources Declarations  
  provider "azurerm" {
    features {}
  }

  variable "resource_group_name" {
    default = "azlbrg"
  }

  variable "location" {
    default = "eastus"
  }
  
  variable "tags" {

  }

# Create virtual network and subnets
  resource "azurerm_virtual_network" "azlblab" {
   name                = "azlbvn"
   address_space       = ["10.0.0.0/16"]
   location            = var.location
   resource_group_name = var.resource_group_name
  }
  
  resource "azurerm_subnet" "websubnet" {
   name                 = "websubnet"
   resource_group_name  = var.resource_group_name
   virtual_network_name = azurerm_virtual_network.azlblab.name
   address_prefixes      = ["10.0.1.0/24"]
  }

  resource "azurerm_subnet" "datasubnet" {
   name                 = "datasubnet"
   resource_group_name  = var.resource_group_name
   virtual_network_name = azurerm_virtual_network.azlblab.name
   address_prefixes      = ["10.0.2.0/24"]
  }
  
# Add Network Security Group for HTTP
  resource "azurerm_network_security_group" "webnsg" {
    name                = "websubnet_nsg"
    location            = "eastus"
    resource_group_name = var.resource_group_name
    
}

  resource "azurerm_network_security_group" "datansg" {
    name                = "datasubnet_nsg"
    location            = "eastus"
    resource_group_name = var.resource_group_name
    
    security_rule {
        name                       = "HTTPS"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "10.0.1.0/24"
        destination_address_prefix = "10.0.2.0/24"
    }

}

# Create Network interfaces - web
  resource "azurerm_network_interface" "web01_nic" {
    name                        = "web01_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "web01_nic"
        subnet_id                     = azurerm_subnet.websubnet.id
        private_ip_address_allocation = "Dynamic"
    }

  }

  resource "azurerm_network_interface" "web02_nic" {
    name                        = "web02_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "web02_nic"
        subnet_id                     = azurerm_subnet.websubnet.id
        private_ip_address_allocation = "Dynamic"
    }

  }

    resource "azurerm_network_interface" "web03_nic" {
    name                        = "web03_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "web03_nic"
        subnet_id                     = azurerm_subnet.websubnet.id
        private_ip_address_allocation = "Dynamic"
    }

  }

    resource "azurerm_network_interface" "data01_nic" {
    name                        = "data01_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "data01_nic"
        subnet_id                     = azurerm_subnet.datasubnet.id
        private_ip_address_allocation = "Dynamic"
    }

  }

    resource "azurerm_network_interface" "data02_nic" {
    name                        = "data02_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "data02_nic"
        subnet_id                     = azurerm_subnet.datasubnet.id
        private_ip_address_allocation = "Dynamic"
    }
  }

# Associate network security group to subnet
resource "azurerm_subnet_network_security_group_association" "webnsgsa" {
  subnet_id                 = azurerm_subnet.websubnet.id
  network_security_group_id = azurerm_network_security_group.webnsg.id
}

resource "azurerm_subnet_network_security_group_association" "datansgsa" {
  subnet_id                 = azurerm_subnet.datasubnet.id
  network_security_group_id = azurerm_network_security_group.datansg.id
}

# Create Web Virtual Machines - 3
  resource "azurerm_virtual_machine" "azlbvm01" {
   name                  = "web01"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.web01_nic.id]
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
     name              = "web01_OSdisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "web01"
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
   name                  = "web02"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.web02_nic.id]
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
     name              = "web02_OSdisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "web02"
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
   name                  = "web03"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.web03_nic.id]
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
     name              = "web03_OSDisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "web03"
     admin_username = "azlblabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }
  
  } 

# Create Web Virtual Machines - 2
resource "azurerm_virtual_machine" "azlbvm04" {
   name                  = "data02"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.data02_nic.id]
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
     name              = "data02_OSDisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "data02"
     admin_username = "azlblabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }
  
  } 

resource "azurerm_virtual_machine" "azlbvm05" {
   name                  = "data01"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.data01_nic.id]
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
     name              = "data01_OSDisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "data01"
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

