# Courseware Demo Template
# Microsoft Azure Administrator: Manage Storage Accounts

# Provider
provider "azurerm" {
    features {}
  }

# Variables
  variable "resource_group_name" {  }
  
  variable "location" {
    default = "eastus"
  }

# Resource Groups
resource "azurerm_resource_group" "rg_storage" {
  name     = "rg-storage-001"
  location = var.location
}

# Virtual networks
# VNET1 - Allow 
resource "azurerm_virtual_network" "vnet1_allow" {
   name                = "vnet1-allow-001"
   address_space       = ["10.0.0.0/16"]
   location            = var.location
   resource_group_name = azurerm_resource_group.rg_storage.name
  }
  
  resource "azurerm_subnet" "snet_vnet1_allow" {
   name                 = "snet-vnet1-allow-001"
   resource_group_name  = azurerm_resource_group.rg_storage.name
   virtual_network_name = azurerm_resource_group.vnet1_allow.name
   address_prefixes      = ["10.0.1.0/24"]
  }

  resource "azurerm_subnet" "snet_bastion_allow" {
   name                 = "AzureBastionSubnet"
   resource_group_name  = azurerm_resource_group.rg_storage.name
   virtual_network_name = azurerm_resource_group.rg_storage.name
   address_prefixes      = ["10.0.253.0/24"]
  }

# VNET2 - Deny
resource "azurerm_virtual_network" "vnet2_deny" {
   name                = "vnet2-deny-001"
   address_space       = ["11.0.0.0/16"]
   location            = var.location
   resource_group_name = azurerm_resource_group.rg_storage.name
  }
  
  resource "azurerm_subnet" "snet_vnet2_deny" {
   name                 = "snet-vnet1-deny-001"
   resource_group_name  = azurerm_resource_group.rg_storage.name
   virtual_network_name = azurerm_resource_group.vnet2_deny.name
   address_prefixes      = ["11.0.1.0/24"]
  }

  resource "azurerm_subnet" "snet_bastion_deny" {
   name                 = "AzureBastionSubnet"
   resource_group_name  = azurerm_resource_group.rg_storage.name
   virtual_network_name = azurerm_resource_group.rg_storage.name
   address_prefixes      = ["11.0.253.0/24"]
  }

# Public IP Address

resource "azurerm_public_ip" "publicip_allow" {
    name                         = "publicip-vnet1-allow-001"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.rg_storage.name
    allocation_method   = "Static"
    sku                 = "Standard"

}
resource "azurerm_public_ip" "publicip_deny" {
    name                         = "publicip-vnet2-deny-001"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.rg_storage.name
    allocation_method   = "Static"
    sku                 = "Standard"

}

# Azure Bastion host
resource "azurerm_bastion_host" "bastion_allows" {
  name                = "bastion-vnet1-allow-001"
  resource_group_name = azurerm_resource_group.rg_storage.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet_bastion_allow.id
    public_ip_address_id = azurerm_public_ip.publicip_allow.id
  }
}

resource "azurerm_bastion_host" "bastion_deny" {
  name                = "bastion-vnet2-deny-001"
  resource_group_name = azurerm_resource_group.rg_storage.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet_bastion_deny.id
    public_ip_address_id = azurerm_public_ip.publicip_deny.id
  }
}

# Add Network Security Group
  resource "azurerm_network_security_group" "nsg_allow" {
    name                = "nsg-vnet1-allow-001"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg_storage.name

}

  resource "azurerm_network_security_group" "nsg_deny" {
    name                = "nsg-vnet2-deny-001"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg_storage.name

}

# Create Network interfaces
  resource "azurerm_network_interface" "ni_vm001" {
    name                        = "ni-vm001-001"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.rg_storage.name

    ip_configuration {
        name                          = "ni-vnet1-allow-ip"
        subnet_id                     = azurerm_subnet.snet_vnet1_allow.id
        private_ip_address_allocation = "Dynamic"
     }

  }
  resource "azurerm_network_interface" "ni_vm002" {
    name                        = "ni-vm002-001"
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
resource "azurerm_subnet_network_security_group_association" "assoc_nsg_allow" {
  subnet_id                 = azurerm_subnet.snet_vnet2_deny.id
  network_security_group_id = azurerm_network_security_group.nsg_deny.id
}

# Storage

# Create BlobStorage w/ container and blob
  resource "azurerm_storage_account" "stblobstorage" {
    name                     = "st-blobstorage-001"
    resource_group_name      = azurerm_resource_group.rg_storage.name
    location                 = var.location
    account_tier             = "standard"
    account_replication_type = "GRS"
    account_kind             = "BlobStorage"
    allow_blob_public_access = "true"  
  }

  resource "azurerm_storage_container" "stblobcontainer" {
    name                    = "documents"
    storage_account_name = azurerm_storage_account.stblobstorage.name
    container_access_type = "public"
  }

  resource "azurerm_storage_blob" "blob_file_01" {
    name                   = "file001.txt"
    storage_account_name   = azurerm_storage_account.stblobstorage.name
    storage_container_name = azurerm_storage_container.stblobcontainer.name
    type                   = "Block"
    source_content         = "This is a basic file"
    #source                 = "some-local-file.zip"
    #If you include a file in the same .zip as your terraform, you might be able to use source = to create the blob with the existing file.
  }

# Create GP v1 Storage
  resource "azurerm_storage_account" "stgpv1" {
    name                     = "st-gpv1storage-001"
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
  storage_account_name = azurerm_storage_account.stgpv1.name
  quota                = 50

  }

   resource "azurerm_storage_share" "fsdata" {
  name                 = "data"
  storage_account_name = azurerm_storage_account.stgpv1.name
  quota                = 50

  }

  resource "azurerm_storage_share_directory" "fsdirbird" {
  name                 = "birds"
  share_name           = azurerm_storage_share.fsimages.name
  storage_account_name = azurerm_storage_account.stgpv1.name
}

resource "azurerm_storage_share_directory" "fsdirdog" {
  name                 = "dogs"
  share_name           = azurerm_storage_share.fsimages.name
  storage_account_name = azurerm_storage_account.stgpv1.name
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
     admin_username = #Enter Username
     admin_password = #Enter Password
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
     admin_username = #Enter Username
     admin_password = #Enter Password
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }