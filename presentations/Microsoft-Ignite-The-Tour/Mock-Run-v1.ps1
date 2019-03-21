 1 code $PROFILE
 2 gcm *azVMPS*, Invoke-AzVMc*,Enter-AzVm*
 3 dir
 4 cd mibender
 5 dir
 6 cd ./VirtualMachines/
 7 dir
 9 get-AzVm -name vm-linux-01 | fl
12 get-AzVm -name vm-linux-01 | select -ExpandProperty StorageProfile
14 (get-AzVm -name vm-linux-01 | select -ExpandProperty StorageProfile).ImageReference
15 get-command get-AzVM*
18 get-command *AzureAD* | more
19 Get-AzureADUser
20 cd $Home
21 dir
22 cd windows azure powershell
23 cd 'windows azure powershell'
24 cd clouddrive
25 dir
26 mkdir DemoDirectory
27 cd DemoDirectory
28 dir
29 code
30 ccls
31 cls
32 code ./new-script.ps1
33 dir
34 ./new-script.ps1
35 code ./new-script.ps1
36 cls