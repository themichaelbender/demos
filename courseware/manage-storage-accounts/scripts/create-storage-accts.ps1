# Create an Azure Storage Account with Azure PowerShell
# Module 1

New-AzStorageAccount -ResourceGroupName rg-az104-eastus-001 `
    -Name st-az104-eastus-ps-001 `
    -Location "eastus" `
    -SkuName Standard_GRS `
    -Kind StorageV2
