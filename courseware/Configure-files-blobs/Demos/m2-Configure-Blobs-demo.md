# Configure Blobs Demos

## Configure Blobs in Azure Storage

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
   4. Mention Azure CDN
   5. Set up Object Replication Rule
      1. Destination: sablobstorage0001
      2. source: blobdata
      3. destination: targetreplication
   6. 

### Configure Azure Blob storage tiers

- Change Hot to Cool
- Configuration Blade > Hot to Cool
- Set on File
  - Browse to file001.txt
  - Select and Change Tier
    - Choose Hot
  - Select file002.txt and Change Tier
    - Choose Archive
  - Select file002.txt and change tier
    - Select Hot and Standard to rehydrate

Verify replication 
### Configure Lifecycle management
    1. Add rule called cool-45-archive-90
    2. If 45 then Move to cool
    3. If 90 then move to archive
    4. Add
    5. Code View
       1. Not Lines 11 and 14
       2. Be able to determine what a policy does by JSON
 Configure Data Protection
    - Add Soft Delete
    - Add Versioning