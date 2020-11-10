# Create and Configure Azure File Share in Portal

In this demo, an Azure File share will be created. You'll learn how to create a FileStorage Storage Account, and add an Azure File Share to it. Then you see how to connect to an Azure File Share from a windows client using SMB.

## Requirements

## Create  FileStorage Storage Account
1. From azure home screen, search for Storage Account and click Create
2. On Basics, enter:
   1. Verify subscription and RG
   2. Storage account name: safilestorage001
   3. Location: East US
   4. Performance: Premium
      1. Show Dropdowns for Standard but choose Premium
   5. Account kind: FileStorage
   6. Replication: ZRS
3. Networking Leave defaults
   1. Discuss options
4. Data protection
   1. Mention Turn on soft delete for file shares
   2. Will show later
5. Advance
6. Review+Create > Create
7. Go to resource

## Create Azure File Share and Directory

1. In resource overview, click File shares
2. Choose +File Share
3. Add share called data w/ capacity of 128GiB > Create
4. Enter Share and click + Add Directory
   1. Name: documents
5. Enter documents directory and click upload
6. Browse to demo files and upload
7. With breadcrumb navigation, return to root of File Shares, click soft delete
   1. Also located under File Service > Soft Delete blade
8. for Data file share, click `...`, show properties
   1. Walk through 
      1. Change size and performance
      2. Snapshots
      3. Backup
         1. Covered in other course
9. return to overview and click connect
   1.  Show each option
       1.  For windows, choose drive letter to map
   2.  Copy code
       1.  Note User is storage account
       2.  Pass is Shared Account key
   3.  Note w/ callout port 445 message about tunnelling 445
10. On east vm, run code in powershell
11. In PowerShell 
    1.  `cd z:\`
    2.  `dir`

