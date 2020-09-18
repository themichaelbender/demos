  # Create cloud shell storage for user
  # Creates random storage starting with pssacs and 16 random characters
  
  # Set Provider
  provider "azurerm" {
    features {}
  }

  # Set Variables
  variable "resource_group_name" {
    default = "test"
  }

  variable "location" {
    default = "eastus"
  }

  #Create random id for storage account
  resource "random_string" "sa_random" {
    length = 14
    upper = false
    lower = true
    min_lower = 7
    min_numeric = 7
    special = false
  }

# Create GPv2 Storage Account for Cloud Shell
  resource "azurerm_storage_account" "sacloudshell" {
    name                     = "pssacs${lower(random_string.sa_random.result)}"
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "standard"
    account_replication_type = "LRS"
    account_kind             = "Storagev2"
    allow_blob_public_access = "true"  
  }
