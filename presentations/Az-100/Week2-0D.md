Objective Domain 2: Implement and manage storage 
	· Create and configure storage accounts
	· May include but not limited to: Configure network access to the storage account; create and configure storage account; generate shared access signature; install and use Azure Storage Explorer; manage access keys; monitor activity log by using Log Analytics; implement Azure storage replication
	· Import and export data to Azure
	· May include but not limited to: Create export from Azure job; create import into Azure job; Use Azure Data Box; configure and use Azure blob storage; configure Azure content delivery network (CDN) endpoints
	· Configure Azure files
	· May include but not limited to: Create Azure file share; create Azure File Sync service; create Azure sync group; troubleshoot Azure File Sync
	· Implement Azure backup
May include but not limited to: Configure and review backup reports; perform backup operation; create Recovery Services Vault; create and configure backup policy; perform a restore operationasdf

## Question 1 - Azure Files Shares
Azure File Shares provide the ability to snapshot shares. This capability provides a read-only point-in-time copy of files within the share. Currently, the limit

1. No new share snapshots are allowed until old snapshots are manually removed.
2. New share snapshots will automatically over-write existing snapshots using a first-in, first out approach.
3. No new share snapshots are allowed until the volume shadow copy service is restarted.
4. New share snapshots will automatically over-write existing snapshots using a first-in, last out approach.

Source: [Azure File Share Snapshots](https://docs.microsoft.com/en-us/azure/storage/files/storage-snapshots-files/?WT.mc_id=qotd-itopstalk-mibender)

## Question 2 - Azure File Shares

Currently, contoso.com is looking to deploy an Azure File Share. They have created a Storage Account in their Azure Portal. When they run the command `New-AzStorageShare`, they receive the following error:

```PowerShell

New-AzStorageShare : The term 'New-AzStorageShare' is not recognized as the name of a cmdlet, function, script file,
or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and
try again.
```

Based on this error, what step should be taken to resolve the issue?

1. Install the current version of Windows PowerShell with Install-Module -Name Pwsh.exe
2. Install the Azure PowerShell module with Install-Module -Name Az
3. Update to the current version of Windows PowerShell with Update-Module -Name Pwsh.exe
4. Update the Azure PowerShell module with Update-Module -Name Az

Source: [Quickstart: Create and manage an Azure file share with Azure PowerShell](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-powershell/?WT.mc_id=qotd-itopstalk-mibender)

## Question 3

Tailwind Traders needs to create a storage account that supports storing files, blobs, and disks, and require the account to support Zone Redundant Storage. Which storage account should they choose?
1. General-purpose V1
2. General-purpose V2
3. Blob
4. Premium-purpose

Source: [Azure storage account overview](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview/?WT.mc_id=qotd-itopstalk-mibender)