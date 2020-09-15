# Build Azure Bastion w/ 1 VM
# Deploys windows 2019 server
# This will deploy a VM, bastion-01, running Windows Server 2019 Datacenter - default installation.
# Once deployed fully, bastion-01 will be available to connect with using Azure Bastion in the Azure Portal.
# Username and Password is specificied in VM build on lines 

# Variables
provider "azurerm" {
    features {}
  }

# Variables & Resources

  variable "resource_group_name" {
    default = "azlab"
  }
  variable "location" {
    default = "eastus"
  }

# Create virtual network and subnets
  
  resource "azurerm_virtual_network" "azlab" {
   name                = "azlabvn"
   address_space       = ["10.0.0.0/16"]
   location            = var.location
   resource_group_name = var.resource_group_name
  }
  
  resource "azurerm_subnet" "azlab" {
   name                 = "azlabsub"
   resource_group_name  = var.resource_group_name
   virtual_network_name = azurerm_virtual_network.azlab.name
   address_prefixes      = ["10.0.1.0/24"]
  }

  resource "azurerm_subnet" "azlabbastionsn" {
   name                 = "AzureBastionSubnet"
   resource_group_name  = var.resource_group_name
   virtual_network_name = azurerm_virtual_network.azlab.name
   address_prefixes      = ["10.0.253.0/24"]
  }


# Public IP Address

resource "azurerm_public_ip" "azlabpublicip" {
    name                         = "azlabpublicip"
    location                     = "eastus"
    resource_group_name          = var.resource_group_name
    allocation_method   = "Static"
    sku                 = "Standard"

}

# Azure Bastion host
resource "azurerm_bastion_host" "azlabbastion" {
  name                = "azlabbastion"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.azlabbastionsn.id
    public_ip_address_id = azurerm_public_ip.azlabpublicip.id
  }
}

# Add Network Security Group
  resource "azurerm_network_security_group" "azlab" {
    name                = "azlabnsg"
    location            = "eastus"
    resource_group_name = var.resource_group_name

}
# Create Network interfaces
  resource "azurerm_network_interface" "azlabni01" {
    name                        = "azlabni01"
    location                    = "eastus"
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "azlabni01"
        subnet_id                     = azurerm_subnet.azlab.id
        private_ip_address_allocation = "Dynamic"
     }

  }

# Associate network security group to subnet
resource "azurerm_subnet_network_security_group_association" "azlab" {
  subnet_id                 = azurerm_subnet.azlab.id
  network_security_group_id = azurerm_network_security_group.azlab.id
}

# Add Storage

# Create BlobStorage w/ container and blob
  resource "azurerm_storage_account" "stblobstorage" {
    name                     = "stblobstorage01"
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "standard"
    account_replication_type = "GRS"
    account_kind             = "BlobStorage"
    allow_blob_public_access = "true"  
  }

  resource "azurerm_storage_container" "stblobcontainer" {
    name                    = "images"
    storage_account_name = azurerm_storage_account.stblobstorage.name
    container_access_type = "private"
  }

  resource "azurerm_storage_blob" "stblob" {
    name                   = "file001.pdf"
    storage_account_name   = azurerm_storage_account.stblobstorage.name
    storage_container_name = azurerm_storage_container.stblobcontainer.name
    type                   = "Block"
    #source                 = "some-local-file.zip"
    #If you include a file in the same .zip as your terraform, you might be able to use source = to create the blob with the existing file.
  }

# Create GP v1 Storage
  resource "azurerm_storage_account" "stgpv1" {
    name                     = "stgpv1storage01"
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "GRS"
    account_kind             = "Storage"
    allow_blob_public_access = "true"  
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

# Create Virtual Machine
    resource "azurerm_virtual_machine" "azlabvm01" {
   name                  = "bastion-01"
   location              = var.location
   resource_group_name   = var.resource_group_name
   network_interface_ids = [azurerm_network_interface.azlabni01.id]
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
     name              = "bastiondisk01"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }
  
   os_profile {
     computer_name  = "bastion-01"
     admin_username = #Enter Username
     admin_password = #Enter Password
     #allow_extension_operations = true
   }
  
   os_profile_windows_config {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
   }

  }