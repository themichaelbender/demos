# Variables
$subscriptionId = "<your-subscription-id>"
$location = "EastUS"
$resourceGroupName = "rg-myresources"
$virtualNetworkName = "vnet-myvnet"
$subnetName = "subnet-myapp"
$bastionSubnetName = "AzureBastionSubnet"
$publicIpAddressName = "pip-mybastion"
$bastionHostName = "bastion-mybastion"
$vmName = "vm-myvm"
$adminUsername = "prod-az-0001"
$adminPassword = ConvertTo-SecureString "23094832##$swxrfAgger4" -AsPlainText -Force

# Login to Azure
Connect-AzAccount

# Set subscription
Set-AzContext -SubscriptionId $subscriptionId

# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a virtual network and subnets
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.0.0/24"
$bastionSubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $bastionSubnetName -AddressPrefix "10.0.1.0/24"
New-AzVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix "10.0.0.0/16" -Subnet $subnetConfig, $bastionSubnetConfig

# Create a public IP address
New-AzPublicIpAddress -Name $publicIpAddressName -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Dynamic

# Create a Network Security Group and allow outbound HTTPS traffic
$nsgRule = New-AzNetworkSecurityRuleConfig -Name "AllowHTTPS" -Protocol Tcp -Direction Outbound -Priority 100 -SourceAddressPrefix "*" -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange 443 -Access Allow
New-AzNetworkSecurityGroup -Name "nsg-myapp" -ResourceGroupName $resourceGroupName -Location $location -SecurityRules $nsgRule

# Create a Bastion Host
$publicIp = Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Name $publicIpAddressName
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $bastionSubnetName -VirtualNetwork (Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $virtualNetworkName)
New-AzBastion -ResourceGroupName $resourceGroupName -Name $bastionHostName -PublicIpAddress $publicIp -VirtualNetwork $subnet.VirtualNetwork -Location $location

# Create a VM
$virtualNetwork = Get-AzVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName
$appSubnetId = ($virtualNetwork.Subnets | Where-Object { $_.Name -eq $subnetName }).Id
$publicIpAddress = Get-AzPublicIpAddress -Name $publicIpAddressName -ResourceGroupName $resourceGroupName
$networkSecurityGroup = Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Name "nsg-myapp"

$nic = New-AzNetworkInterface -Name "nic-myvm" -ResourceGroupName $resourceGroupName -Location $location -SubnetId $appSubnetId -PublicIpAddressId $publicIpAddress.Id -NetworkSecurityGroupId $networkSecurityGroup.Id

$vmConfig = New-AzVMConfig -VMName $vmName -VMSize "Standard_D2s_v3" |
    Set-AzVMOperatingSystem -Windows
