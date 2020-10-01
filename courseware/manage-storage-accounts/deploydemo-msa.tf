# Courseware Demo Template
# Microsoft Azure Administrator: Manage Storage Accounts
# Before using, add Password and Username value to the respective variables.
# WARNING: This template utilizes resources in azure that will run up your bill if left alone for a few days.
# Delete the Resouce Group when you are done

# Basic instructions
# Connect to Azure with whatever tooling you wish
# I recommend Azure Cloud Shell
# Copy this .tf file into a directory of a system with Terraform installed
# Run the following commands:
# terraform init
# terraform apply

# When finished with the demos run:
# terraform destory




# Provider
provider "azurerm" {
    features {}
  }

# Variables
  variable "resource_group_name" { 
      default = "rg-storage-001"
   }
  
  variable "location" {
    default = "eastus"
  }

  variable "password" {
    type = string
    description = "Administrator password for virtual machine"
    default   = #Enter Password
  }

  variable "username"   {
    type = string
    description = "Administrator user name for virtual machine"
    default   = #Enter Username
  }

    #Create random id for storage account
  resource "random_string" "sa_random" {
    length = 8
    upper = false
    lower = true
    #min_lower = 9
    #min_numeric = 9
    special = false
  }
# Resource Groups
resource "azurerm_resource_group" "rg_storage" {
  name     = "rg-storage-001"
  location = var.location
}

# Virtual networks
# VNET1 - Allow 
resource "azurerm_virtual_network" "vnet1_allow" {
   name                = "vnet1-allow"
   address_space       = ["10.0.0.0/16"]
   location            = var.location
   resource_group_name = var.resource_group_name
   depends_on          = [azurerm_resource_group.rg_storage]
  }
  
  resource "azurerm_subnet" "snet_vnet1_allow" {
   name                 = "snet-vnet1-allow"
   resource_group_name  = var.resource_group_name
   virtual_network_name = azurerm_virtual_network.vnet1_allow.name
   address_prefixes      = ["10.0.1.0/24"]
  }

  resource "azurerm_subnet" "snet_bastion_allow" {
   name                 = "AzureBastionSubnet"
   resource_group_name  = azurerm_resource_group.rg_storage.name
   virtual_network_name = azurerm_virtual_network.vnet1_allow.name
   address_prefixes      = ["10.0.253.0/24"]
  }

# VNET2 - Deny
resource "azurerm_virtual_network" "vnet2_deny" {
   name                = "vnet2-deny"
   address_space       = ["11.0.0.0/16"]
   location            = var.location
   resource_group_name = azurerm_resource_group.rg_storage.name
   depends_on          = [azurerm_resource_group.rg_storage]
  }
  
  resource "azurerm_subnet" "snet_vnet2_deny" {
   name                 = "snet-vnet1-deny"
   resource_group_name  = azurerm_resource_group.rg_storage.name
   virtual_network_name = azurerm_virtual_network.vnet2_deny.name
   address_prefixes      = ["11.0.1.0/24"]
  }

  resource "azurerm_subnet" "snet_bastion_deny" {
   name                 = "AzureBastionSubnet"
   resource_group_name  = azurerm_resource_group.rg_storage.name
   virtual_network_name = azurerm_virtual_network.vnet2_deny.name
   address_prefixes      = ["11.0.253.0/24"]
  }

# Public IP Address

resource "azurerm_public_ip" "publicip_allow" {
    name                         = "publicip-vnet1-allow"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.rg_storage.name
    allocation_method   = "Static"
    sku                 = "Standard"

}
resource "azurerm_public_ip" "publicip_deny" {
    name                         = "publicip-vnet2-deny"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.rg_storage.name
    allocation_method   = "Static"
    sku                 = "Standard"

}

# Azure Bastion host
resource "azurerm_bastion_host" "bastion_allows" {
  name                = "bastion-vnet1-allow"
  resource_group_name = azurerm_resource_group.rg_storage.name
    location          = var.location
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet_bastion_allow.id
    public_ip_address_id = azurerm_public_ip.publicip_allow.id
  }
}

resource "azurerm_bastion_host" "bastion_deny" {
  name                = "bastion-vnet2-deny"
  resource_group_name = azurerm_resource_group.rg_storage.name
    location          = var.location
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet_bastion_deny.id
    public_ip_address_id = azurerm_public_ip.publicip_deny.id
  }
}

# Add Network Security Group
  resource "azurerm_network_security_group" "nsg_allow" {
    name                = "nsg-vnet1-allow"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg_storage.name

}

  resource "azurerm_network_security_group" "nsg_deny" {
    name                = "nsg-vnet2-deny"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg_storage.name

}

# Create Network interfaces
  resource "azurerm_network_interface" "ni_vm001" {
    name                        = "ni-vm001"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.rg_storage.name

    ip_configuration {
        name                          = "ni-vnet1-allow-ip"
        subnet_id                     = azurerm_subnet.snet_vnet1_allow.id
        private_ip_address_allocation = "Dynamic"
     }

  }
  resource "azurerm_network_interface" "ni_vm002" {
    name                        = "ni-vm002"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.rg_storage.name

    ip_configuration {
        name                          = "ni-vnet2-deny-ip"
        subnet_id                     = azurerm_subnet.snet_vnet2_deny.id
        private_ip_address_allocation = "Dynamic"
     }

  }
# Associate network security group to subnet
resource "azurerm_subnet_network_security_group_association" "assoc_nsg_allow" {
  subnet_id                 = azurerm_subnet.snet_vnet1_allow.id
  network_security_group_id = azurerm_network_security_group.nsg_allow.id
}
resource "azurerm_subnet_network_security_group_association" "assoc_nsg_deny" {
  subnet_id                 = azurerm_subnet.snet_vnet2_deny.id
  network_security_group_id = azurerm_network_security_group.nsg_deny.id
}

# Storage

# Create BlobStorage w/ container and blob
  resource "azurerm_storage_account" "sablob001" {
    name                     = "sablob001"
    resource_group_name      = azurerm_resource_group.rg_storage.name
    location                 = var.location
    account_tier             = "standard"
    account_replication_type = "GRS"
    account_kind             = "BlobStorage"
    allow_blob_public_access = "true"  
  }

  resource "azurerm_storage_container" "sablobcontainer" {
    name                    = "documents"
    storage_account_name = azurerm_storage_account.sablobstorage.name
    container_access_type = "container"
  }

  resource "azurerm_storage_blob" "blob_01" {
    name                   = "webpage001.html"
    storage_account_name   = azurerm_storage_account.sablobstorage.name
    storage_container_name = azurerm_storage_container.sablobcontainer.name
    type                   = "Block"
    source         = "webpage001.html"
    content_type            = "text/html"
    #source                 = "some-local-file.zip"
    #If you include a file in the same .zip as your terraform, you might be able to use source = to create the blob with the existing file.
  }
# Create GP v1 Storage
  resource "azurerm_storage_account" "sastorage001" {
    name                     = "sastorage001"
    resource_group_name      = azurerm_resource_group.rg_storage.name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "Storage"
    allow_blob_public_access = "false"  
  }

# Add File Shares and Directories
# Does not include any files
 resource "azurerm_storage_share" "fsimages" {
  name                 = "images"
  storage_account_name = azurerm_storage_account.sastorage001.name
  quota                = 50

  }

   resource "azurerm_storage_share" "fsdata" {
  name                 = "data"
  storage_account_name = azurerm_storage_account.sastorage001.name
  quota                = 50

  }

  resource "azurerm_storage_share_directory" "fsdirbird" {
  name                 = "birds"
  share_name           = azurerm_storage_share.fsimages.name
  storage_account_name = azurerm_storage_account.sastorage001.name
}

resource "azurerm_storage_share_directory" "fsdirdog" {
  name                 = "dogs"
  share_name           = azurerm_storage_share.fsimages.name
  storage_account_name = azurerm_storage_account.sastorage001.name
}
# Virtual Machines

# Create Virtual Machine
    resource "azurerm_virtual_machine" "vm001" {
   name                  = "vm001"
   location              = var.location
   resource_group_name   = azurerm_resource_group.rg_storage.name
   network_interface_ids = [azurerm_network_interface.ni_vm001.id]
   vm_size               = "Standard_B1ms"
   delete_os_disk_on_termination = true
   delete_data_disks_on_termination = true
  
   storage_image_reference {
     publisher = "MicrosoftWindowsServer"
     offer     = "WindowsServer"
     sku       = "2019-Datacenter"
     version   = "latest"
   }
  
   storage_os_disk {
     name              = "disk-vm001-01"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "vm001"
     admin_username = var.username
     admin_password = var.password
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }

   resource "azurerm_virtual_machine" "vm002" {
   name                  = "vm002"
   location              = var.location
   resource_group_name   = azurerm_resource_group.rg_storage.name
   network_interface_ids = [azurerm_network_interface.ni_vm002.id]
   vm_size               = "Standard_B1ms"
   delete_os_disk_on_termination = true
   delete_data_disks_on_termination = true
  
   storage_image_reference {
     publisher = "MicrosoftWindowsServer"
     offer     = "WindowsServer"
     sku       = "2019-Datacenter"
     version   = "latest"
   }
  
   storage_os_disk {
     name              = "disk-vm002-01"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "vm002"
     admin_username = var.username
     admin_password = var.password
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }