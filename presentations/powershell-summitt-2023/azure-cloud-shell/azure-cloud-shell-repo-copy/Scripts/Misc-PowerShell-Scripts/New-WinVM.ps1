New-AzResourceGroup -Name 'mibenderdemo' -Location EastUS

$cred = Get-Credential
$vmParams = @{
  ResourceGroupName = 'mibenderDemo'
  Name = 'DemoWin'
  Location = 'eastus'
  ImageName = 'Win2016Datacenter'
  Credential = $cred
  OpenPorts = 3389
}
New-AzVM @vmParams