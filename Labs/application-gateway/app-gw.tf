# Create lab environment for Configure an Azure Application Gateway
# Creates an images tier w/ 2 VMs (img01-02)
# Creates a video tier w/ 2 VMs (vid01-02)
# Both tiers include subnet and NSG
# All VMs are bootstrapped with IIS and custom webpage w/ name
# Updates 05-08-2020 - Modifed
# Variables - Providers - Resources Declarations  
  provider "azurerm" {
    features {}
  }

  variable "resource_group_name" {
    default = "appgwrg"
  }

  variable "location" {
    default = "eastus"
  }
  
  variable "tags" {

  }

# Create virtual network and subnets
  resource "azurerm_virtual_network" "appgwlab" {
   name                = "appgwvn"
   address_space       = ["10.1.0.0/16"]
   location            = var.location
   resource_group_name = var.resource_group_name
  }
  
  resource "azurerm_subnet" "agsubnet" {
   name                 = "agsubnet"
   resource_group_name  = var.resource_group_name
   virtual_network_name = azurerm_virtual_network.appgwlab.name
   address_prefixes      = ["10.1.1.0/24"]
  }

  resource "azurerm_subnet" "besubnet" {
   name                 = "besubnet"
   resource_group_name  = var.resource_group_name
   virtual_network_name = azurerm_virtual_network.appgwlab.name
   address_prefixes      = ["10.1.2.0/24"]
  }
  
# Add Network Security Group for HTTP
  resource "azurerm_network_security_group" "agnsg" {
    name                = "_nsg"
    location            = "eastus"
    resource_group_name = var.resource_group_name

        security_rule {
        name                       = "HTTPS"
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

# Create Network interfaces - web
  resource "azurerm_network_interface" "img01_nic" {
    name                        = "img01_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "img01_nic"
        subnet_id                     = azurerm_subnet.besubnet.id
        private_ip_address_allocation = "Dynamic"
    }

  }

  resource "azurerm_network_interface" "img02_nic" {
    name                        = "img02_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "img02_nic"
        subnet_id                     = azurerm_subnet.besubnet.id
        private_ip_address_allocation = "Dynamic"
    }

  }

    resource "azurerm_network_interface" "video01_nic" {
    name                        = "video01_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "video01_nic"
        subnet_id                     = azurerm_subnet.besubnet.id
        private_ip_address_allocation = "Dynamic"
    }

  }

    resource "azurerm_network_interface" "video02_nic" {
    name                        = "video02_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "video02_nic"
        subnet_id                     = azurerm_subnet.besubnet.id
        private_ip_address_allocation = "Dynamic"
    }

  }

    resource "azurerm_network_interface" "img01_nic" {
    name                        = "img01_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "img01_nic"
        subnet_id                     = azurerm_subnet.besubnet.id
        private_ip_address_allocation = "Dynamic"
    }
  }

# Associate network security group to subnet
resource "azurerm_subnet_network_security_group_association" "agnsgsa" {
  subnet_id                 = azurerm_subnet.besubnet.id
  network_security_group_id = azurerm_network_security_group.agnsg.id
}

# Create Web Virtual Machines - 3
  resource "azurerm_virtual_machine" "img01_vm" {
   name                  = "img01"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.img01_nic.id]
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
     name              = "img01_OSdisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "img01"
     admin_username = "appgwlabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }

  resource "azurerm_virtual_machine" "img02_vm" {
   name                  = "img02"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.img02_nic.id]
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
     name              = "img02_OSdisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "img02"
     admin_username = "appgwlabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }

resource "azurerm_virtual_machine" "video01_vm" {
   name                  = "video01"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.video01_nic.id]
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
     name              = "video01_OSDisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "video01"
     admin_username = "appgwlabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }
  
  } 

# Create Web Virtual Machines - 2
resource "azurerm_virtual_machine" "video02_vm" {
   name                  = "video02"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.img01_nic.id]
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
     name              = "video02_OSDisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "video02"
     admin_username = "appgwlabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }
  
  } 

resource "azurerm_virtual_machine" "web01_vm" {
   name                  = "web01"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.video02_nic.id]
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
     name              = "web01_OSDisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "web01"
     admin_username = "appgwlabadmin"
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
  virtual_machine_id = azurerm_virtual_machine.img01_vm.id
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
  virtual_machine_id = azurerm_virtual_machine.img02_vm.id
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
  virtual_machine_id = azurerm_virtual_machine.video01_vm.id
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

resource "azurerm_virtual_machine_extension" "iis-vm-ext-04" {
  #depends_on=[azurerm_windows_virtual_machine.azlbvm]
  count = 1
  name = "iis-vm-ext-04"
  virtual_machine_id = azurerm_virtual_machine.video02_vm.id
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

resource "azurerm_virtual_machine_extension" "iis-vm-ext-05" {
  #depends_on=[azurerm_windows_virtual_machine.azlbvm]
  count = 1
  name = "iis-vm-ext-05"
  virtual_machine_id = azurerm_virtual_machine.web01_vm.id
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
