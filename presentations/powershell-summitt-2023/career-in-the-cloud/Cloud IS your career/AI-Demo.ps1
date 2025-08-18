I can try to write a PowerShell script for you, but I cannot guarantee that it will work as expected. You may need to modify it according to your specific requirements and test it before using it in production. Here is a possible script based on the information I found in the web search results¹²³⁴⁵:

```powershell
# Login to Azure and select subscription
az login
az account set --subscription "your-subscription-name"

# Create resource group
$rgName = "TestRG1"
$location = "EastUS"
New-AzResourceGroup -Name $rgName -Location $location

# Create virtual network and subnet
$vnetName = "VNet1"
$subnetName = "FrontEnd"
$vnet = New-AzVirtualNetwork -ResourceGroupName $rgName -Location $location `
  -Name $vnetName -AddressPrefix "10.1.0.0/16" `
  -Subnet @{Name=$subnetName;AddressPrefix="10.1.0.0/24"}

# Create bastion subnet and public IP address
$bastionSubnetName = "AzureBastionSubnet"
$bastionSubnet = New-AzVirtualNetworkSubnetConfig -Name $bastionSubnetName `
  -AddressPrefix "10.1.1.0/26"
$vnet | Add-AzVirtualNetworkSubnetConfig -Name $bastionSubnet.Name `
  -AddressPrefix $bastionSubnet.AddressPrefix | Set-AzVirtualNetwork

$bastionPublicIp = New-AzPublicIpAddress -ResourceGroupName $rgName `
  -name "VNet1-ip" -AllocationMethod Static -Sku Standard

# Create bastion host
$bastionHost = New-AzBastionHost -ResourceGroupName $rgName `
  -Name "VNet1-bastion" `
  -PublicIpAddressId $bastionPublicIp.Id `
  -VirtualNetworkId $vnet.Id

# Create three virtual machines with Windows
$vmNames = @("TestVM1", "TestVM2", "TestVM3")
$vmSize = "Standard_D2s_v3"
$adminUsername = "azureuser"
$adminPassword = ConvertTo-SecureString "your-password" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($adminUsername, $adminPassword)

foreach ($vmName in $vmNames) {
  # Create public IP address (optional)
  #$publicIp = New-AzPublicIpAddress -ResourceGroupName $rgName `
  #  -name "$vmName-ip" -AllocationMethod Dynamic

  # Create network interface card
  $nic = New-AzNetworkInterface -ResourceGroupName $rgName `
    -Location $location `
    -Name "$vmName-nic" `
    #-PublicIpAddressId $publicIp.Id `
    -SubnetId $vnet.Subnets[0].Id

  # Create virtual machine
  $vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize
  Set-AzVMOperatingSystem -VM $vmConfig `
    -Windows `
    -ComputerName $vmName `
    -Credential $cred `
    -ProvisionVMAgent `
    -EnableAutoUpdate
  Set-AzVMSourceImage -VM $vmConfig `
    -PublisherName 'MicrosoftWindowsServer' `
    -Offer 'WindowsServer' `
    -Skus '2016-Datacenter' `
    -Version latest
  Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id
  New-AzVM -ResourceGroupName $rgName -Location $location -VM $vmConfig
}

# Connect to a VM using Azure Bastion
Connect-AzVMRdpViaBastionHost [-ResourceGroupName] <String> [-VmName] <String> [-BastionHostName] <String>
```

Source: Conversation with Bing, 4/25/2023
(1) Deploy Bastion:PowerShell - Azure Bastion | Microsoft Learn. https://learn.microsoft.com/en-us/azure/bastion/bastion-create-host-powershell.
(2) Run scripts in an Azure Windows VM - Azure Virtual Machines. https://learn.microsoft.com/en-us/azure/virtual-machines/windows/run-scripts-in-vm.
(3) Azure Bastion: Use Native RDP Client to Connect to VMs. https://jeffbrown.tech/azure-bastion-rdp-native-client/.
(4) Running PowerShell scripts remotely on Azure virtual machines. https://4sysops.com/archives/running-powershell-scripts-remotely-on-azure-virtual-machines/.
(5) Quickstart: Create a Windows virtual machine in Azure with PowerShell. https://learn.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-powershell.