# Master the Cloud with Azure Cloud Shell

You already know PowerShell is the key to on-premises workloads. Now take the power of the shell into the Cloud with Azure Cloud Shell. This demo-packed session will introduce you to Azure Cloud Shell, and provide plenty of tips to be immediately effective in using the command line to manage your Azure resources from anywhere.

## Pre-Reqs

Deploy Windows VM
Deploy Linux VM
Azure Account Extension -VS Code

Shell with GIT already authenticated
## Demos

1. Intro to cloud shell (2)
   1. Marketing Slides
2. Where is Cloud Shell Available?
   1. Azure Portal
   2. Visual Studio CodeU
   3. shell.azure.com
3. Walk through initial setup (2)
   1. Add drive through advanced settings
   2. Run through taskbar options
   3. View Storage
   4. Upload Script
   5. Open code with {}
4. Exploring the Shell
   1. Dir to view subs & Resources
   2. Discuss Azure Drive
   3. Explore down to VMs
   4. Demo: View ImageReference for VM
5. find Az commands (2)
   1. Find AZ* and AzureAD*
   2. Demo: get-command get-AzVM*
6. Explore to $Home
   1. create directory
      1. PS> mk
   2. Create script in code and save here
   3. 
   4. Open script
7. Edit Script in VS Code Editor (2)
8. View and Download History
   1. get-History
   2. Get-History | export-csv History.csv
   3. Manage File Share > Download via Azure Portal
9.  Remote into VMs
   4. gcm *azVMPS*, Invoke-AzVMc*,Enter-AzVm*

```PowerShell
# Enable VMs
$win = 'vm-windows-01'
$lnx = 'vm-linux-01'
$rsg = 'mitt-cloudshell-demo'
$cred = Get-credential

# Enable Azure Remoting - Windows VM
Enable-AzVMPSRemoting -Name $win -ResourceGroupName $rsg -Protocol https -OsType Windows

# Enable Azure Remoting - Linux VM
Enable-AzVMPSRemoting -Name $lnx -ResourceGroupName $rsg -Protocol ssh -OsType Linux

# Fan Out to VMs
# Windows VM
Invoke-AzVMCommand -Name $win -ResourceGroupName $rsg -ScriptBlock {get-service win*} -Credential $cred

# Linux VM
Invoke-AzVMCommand -Name $lnx -ResourceGroupName $rsg -ScriptBlock {uname -a} -UserName michael -KeyFilePath /home/michael/.ssh/id_rsa

# Connect to VM with Remoting
Enter-AzVM -name $win -ResourceGroupName $rsg -Credential $cred
whoami
get-service | where status -eq stopped
```

1. Deploy resources from Azure-Samples (2)
   ```PowerShell

   New-AzResourceGroup -Name 'cloudshell-demo-02' -location 'westeurope'

get-azResource -ResourceGroupName 'cloudshell-demo-02'

New-AzureRmResourceGroupDeployment -Name 'cloudshell-demo' -ResourceGroupName 'cloudshell-demo-02' -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-automatic-static-ip/azuredeploy.json   -AsJob

get-job | format-list

get-azResource -ResourceGroupName 'cloudshell-demo-02'

get-azResource -ResourceGroupName 'cloudshell-demo-02' | Format-Table
```
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
