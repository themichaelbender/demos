  # Create cloud shell storage for user
  # Creates random storage starting with pssacs and 18 random characters
  # storage account name example: pssacse6676dpb2ti780zdx7
  
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
    length = 18
    upper = false
    lower = true
    min_lower = 9
    min_numeric = 9
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
