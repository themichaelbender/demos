# Configure Blobs Demos
## General instructions for all demos in module 2 - Configure Azure Blobs
## Note: These may not contain all actual steps, but will provide you a guide of the process for each task.

## Configure Blobs in Azure Storage
In this lab, You learn how to configure Blobs in Azure Storage.

First, you’ll see how to create a General Purpose v2 Storage Account that will be home to blobs uploaded from a local file system. Then you’ll walk through configuration options in the azure portal so you are familiar with all the configuration options, and where you apply them. Items like access

### Create a GPv2 Storage account

1. Create a GPv2 Storage Account
   1. sagpv2storage001
   2. LRS
   3. Networking defaults
   4. Advanced
      1. mention
   5. Disable Public Access
2. Create a Blob container called blobdata
3. Upload files to blobdata
   1. file001-003
   2. Advanced
      1. Note Auth Type
      2. Blob Type
      3. Note change of Access Tier
         1. Change to Cool
4. Show options for Blob container
   1. Access Policy
   2. Change Access
   3. Properties
5. Show error when Change Access Level


### Configure Azure Blobs

1. Blob Service >
   1. Review Containers
   2. Review Custom Domain
      1. 2 methods with both requiring CNAME records
   3. Review Data Protection options
      1. Configure Data Protection
          1. Add Soft Delete
          2. Add Versioning
   4. Mention Azure CDN

### Configure Azure Blob storage tiers

This final demo will focus on Azure Blob Storage Tiers. You'll see how to configure storage tiers at the storage account, container, and blob level. Also, you'll see how to perform migrations across tiers. Last item will be to cover automating tiering of objects in Storage Accounts with Lifecycle management.

1. Configure Storage Tiers
   1. Change Hot to Cool
      1. Configuration Blade > Hot to Cool
      2. Set on File
      3. Browse to file001.txt
      4. Select and Change Tier
      5. Choose Hot
   2. Change Cool to Archive
      1. Select file002.txt and Change Tier
      2. Choose Archive
      3. Select file002.txt and change tier
         1. Select Hot and Standard to rehydrate
      4. Verify
   3. Configure Lifecycle management policy
    1. Add rule called cool-45-archive-90
       1. If 45 then Move to cool
       2. If 90 then move to archive
       3. Click Add
    2. View Policy Code View
       1. Note Lines 11 and 14
       2. Be able to determine what a policy does by JSON
       3. Possible use could be pushing out policy with Storage Account creation using ARM Templates
