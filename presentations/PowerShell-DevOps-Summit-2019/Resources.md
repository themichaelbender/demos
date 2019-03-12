# Azure Cloud Shell Resources

## Commands

``` Switch to PowerShell from Bash: pwsh ```
``` To exit Help screen: :q ```
``` MOTD: Download files or directories from the cloudshell: Export-File ```
```
#Enter Code in Cloud Shell
code

```
1 get-azvm
   2 get-azvm | gm
   3 get-az | select Name,StorageProfile
   4 Get-AzVm | select Name,StorageProfile
   5 ((get-azvm).StorageProfile).Datadisks
   6 ((get-azvm).StorageProfile).OsDisk
   7 ((get-azvm).StorageProfile).OsDisk | gm
   8 get-azvm
   9 ((get-azvm).StorageProfile).OsDisk
  10 ((get-azvm).StorageProfile).Datadisks
  ```
  [VS Code in Cloud Shell Blog](https://azure.microsoft.com/en-us/blog/cloudshelleditor/)