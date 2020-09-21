# Create lab environment for Configure an Azure Load Balancer
# Creates 2 VMs in an Availability Set w/ Virtual Network
# Updated - Bootstrapping OS with IIS
# Needed - Azure Bastion & Subnet
#        - Change to using Public Website

# Terraform Reference: https://www.terraform.io/docs/providers/azurerm/r/storage_account.html

provider "azurerm" {
    features {}
  }

# Variables & Resources

  variable "resource_group_name" {
    default = "rg-az104-st001"
  }
  variable "location" {
    default = "eastus"
  }
# Create Resource Group
resource "azurerm_resource_group" "rgaz104" {
  name     = var.resource_group_name
  location = var.location
}

  # Create BlobStorage
    resource "azurerm_storage_account" "stblobstorage" {
    name                     = "stblobstorage001"
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "Premium"
    account_replication_type = "RAGRS"
    account_kind             = "BlobStorage"   

    tags = {
        environment = "az104demo"
    }
    }
  
  # Create GP v1 Storage
    resource "azurerm_storage_account" "stblobstorage" {
    name                     = "stgpv1storage001"
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "GRS"
    account_kind             = "Storage"   

    tags = {
        environment = "az104demo"
    }
    }

  # Create GP v2
    resource "azurerm_storage_account" "stblobstorage" {
    name                     = "stgpv1storage001"
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "GRS"
    account_kind             = "file_storage"   

    tags = {
        environment = "az104demo"
    }
    }