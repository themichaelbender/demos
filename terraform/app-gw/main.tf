# Create lab environment for Configure an Azure Application Gateway
# Creates an images tier w/ 2 VMs (web01-02)
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
    name                = "appgw_nsg"
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
  resource "azurerm_network_interface" "web01_nic" {
    name                        = "web01_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "web01_nic"
        subnet_id                     = azurerm_subnet.besubnet.id
        private_ip_address_allocation = "Dynamic"
    }

  }

  resource "azurerm_network_interface" "web02_nic" {
    name                        = "web02_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "web02_nic"
        subnet_id                     = azurerm_subnet.besubnet.id
        private_ip_address_allocation = "Dynamic"
    }

  }

    resource "azurerm_network_interface" "web03_nic" {
    name                        = "web03_nic"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "web03_nic"
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
  resource "azurerm_virtual_machine" "web01_vm" {
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
     admin_username = "appgwlabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }

  resource "azurerm_virtual_machine" "web02_vm" {
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
     admin_username = "appgwlabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }

resource "azurerm_virtual_machine" "web03_vm" {
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
     admin_username = "appgwlabadmin"
     admin_password = "Password1234!"
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }
  
  } 

  
  # Add code for IIS build out
resource "azurerm_virtual_machine_extension" "iis-vm-ext-01" {
  #depends_on=[azurerm_windows_virtual_machine.azlbvm]
  count = 1
  name = "iis-vm-ext-01"
  virtual_machine_id = azurerm_virtual_machine.web01_vm.id
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

resource "azurerm_virtual_machine_extension" "iis-vm-ext-02" {
  #depends_on=[azurerm_windows_virtual_machine.azlbvm]
  count = 1
  name = "iis-vm-ext-02"
  virtual_machine_id = azurerm_virtual_machine.web01_vm.id
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

resource "azurerm_virtual_machine_extension" "iis-vm-ext-03" {
  #depends_on=[azurerm_windows_virtual_machine.azlbvm]
  count = 1
  name = "iis-vm-ext-03"
  virtual_machine_id = azurerm_virtual_machine.web01_vm.id
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
