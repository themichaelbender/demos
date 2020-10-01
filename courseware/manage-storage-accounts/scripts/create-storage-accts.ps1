# Create an Azure Storage Account with Azure PowerShell
# Optional
New-AzStorageAccount -ResourceGroupName rg-storage-001 `
    -Name sagpv2storageps001 `
    -Location "eastus" `
    -SkuName Standard_GRS `
    -Kind StorageV2

# View all storage accounts
Get-AzStorageAccount | where ResourceGroupName -eq "rg-storage-001" | ft