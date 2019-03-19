# Azure Cloud Shell Resources
## Meeting Important 
* Dismount-CloudDrive
  * Reset Storage 
  * AccountAdvance 
  * Settings
* Local Experience
  * Requires Port
  * VS Code
  * Azure Storage Explorer
* Possible Exchange Demos
* Option in Cloud Shell for Tab Complete
  * Set-PSReadLine Look at edit mode 'Notes

MOTD: To edit files in the shell, type: code, vim, emacs, vi or nano

MOTD: Scripts installed with 'Install-Script' can be run from the shell

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

  ## Videos and Other
  [Automate Tasks using Azure Cloud Shell](https://www.youtube.com/watch?v=GwT1j3JHSgw)
  [Azure Cloud Shell](https://www.youtube.com/watch?v=8Hicsru9x8o&t=293s)

  [Master Azure Cloud Shell by Thomas Maurer](https://www.thomasmaurer.ch/2019/01/azure-cloud-shell/)