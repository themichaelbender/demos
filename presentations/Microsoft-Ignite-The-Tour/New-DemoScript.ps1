
## Pre-Reqs
[Azure Subscrition](https://azure.microsoft.com/en-us/free/?WT.mc_id=MSIgniteTheTour-github-mibender)

Deploy Windows VM
Deploy Linux VM

## Demo 1 - Exploring the Shell
This series of demos includes the setup, configuration, and exploration of Azure Cloud Shell. 

dir
cd mibender
cd ./VirtualMachines/
dir
get-AzVm -name vm-linux-01 | fl
get-AzVm -name vm-linux-01 | select -ExpandProperty StorageProfile
(get-AzVm -name vm-linux-01 | select -ExpandProperty StorageProfile).ImageReference
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
```PowerShell

```
## Demo 2 -Working with Visual Studio Code

## Demo 3 - Remoting into VMs
This set of demos covers remoting into VMs in Azure.

```PowerShell
# View commands in Azure Cloud Shell for Remoting
gcm *azVMPS*, Invoke-AzVMc*,Enter-AzVm*

# Variables
$win =
$lnx =
$rsg =
$cred = get-credential

# Windows VM
Enable-AzVMPSRemoting -Name $win -ResourceGroupName $rsg -Protocol https -OsType Windows

# Linux VM
Enable-AzVMPSRemoting -Name $lnx -ResourceGroupName $rsg -Protocol ssh -OsType Linux

# Fan Out to VMs
# Windows VM
Invoke-AzVMCommand -Name tmdemowin-01 -ResourceGroupName TM-DEMO-CLOUDSHELL-RG -ScriptBlock {get-service win*} -Credential $cred

# Linux VM
Invoke-AzVMCommand -Name $lnx -ResourceGroupName $rsg -ScriptBlock {uname -a} -UserName michael -KeyFilePath /home/michael/.ssh/id_rsa

# Connect to VM with Remoting

Enter-AzVM -name $win -ResourceGroupName $rsg -Credential $cred
whoami
get-service | where status -eq stopped

## Demo 4 - Deploying Resources and GIT
New-AzResourceGroup -Name 'cloudshell-demo-02' -location 'westeurope'

get-azResource -ResourceGroupName 'cloudshell-demo-02'

New-AzureRmResourceGroupDeployment -Name 'cloudshell-demo' -ResourceGroupName 'cloudshell-demo-02' -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-automatic-static-ip/azuredeploy.json   -AsJob

get-job | format-list

get-azResource -ResourceGroupName 'cloudshell-demo-02'

get-azResource -ResourceGroupName 'cloudshell-demo-02' | Format-Table

# Setting up GIT

cd $home/clouddrive/michael/
mkdir github
cd ./github
git clone <Path to repo>
# Set remote url to repository; SSH must be created and stored
git remote set-url origin git@github.com:themichaelbender-ms/demos.git
git status
git branch
git checkout -b demo-cs
code ./New-DemoScript.ps1 # Create a new script, add code, and save
git status
git add . # Adds all changes
git commit -m 'New Script'
git status
git push -u origin demo-cs


```
# Extra Stuff 


2. Use GIT to clone demo folder w/ Scripts (2)
   1. 42 cd $Home
  43 dir
  44 cd ./clouddrive/
  45 dir
  46 mkdir github
  47 cd ./github/
  48 git clone https://github.com/themichaelbender-ms/demos.git
  49 git status
  50 dir
  51 cd demos
  52 git status
  53 git branch
  54 git checkout -b demobranch-cs
  71 dir
  72 cd ./demoscripts
  73 dir
  74 code ./get-stoppedServices.ps1
  78 git commit -m 'Script Update' -a
 git remote set-url origin git@github.com:themichaelbender-ms/demos.git
   79 git push -u origin demobranch-cs
3.  Show Microsoft Learn module on X and show Azure Cloud Shell (2)
4.  Close with Slide of iphone screen accessing cloud shell (1)