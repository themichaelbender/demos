
## Using Shared Account Key
`az storage container list`
az storage container list --account-name stanonblobstorage001 --account-key <InsertKey>
az storage blob list --account-name stanonblobstorage001 --container-name blobcontainer001 --account-key <insertKey>
### Regen Key in UI

az storage blob list --account-name stanonblobstorage001 --container-name blobcontainer001 --account-key <insertKey>