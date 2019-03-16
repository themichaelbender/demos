# Using Get-AzVMSize 

Finding the right virtual machine for you needs can be difficult especially with all of the options available. And chances are, new options are coming day so you may need to regularly check the VMs available. Sure, you could do this through the GUI, but using PowerShell makes it quick and easy to see all of the VM types so you can get to building.


## General use

```PowerShell

Get-AzVMSize

```

### Finding Specific Types
Let's say you need to find out what types of VMs are available in a specific region, say East US, with skus that include 8 cores only.

```PowerShell

Get-AzVMSize -Location EastUS | Where NumberOfCores -EQ '8'`

```

Now you want to refine the list even further to include VM types that have a maximum data disk count (meaning the number a data disks that can be attached to the VM) of 16.

```PowerShell

Get-AzVMSize -Location EastUS | Where {($_.NumberOfCores -EQ '8') -or ($_.MaxDataDiskCount -eq '16')}

```

```PowerShell

Get-AzVMSize -ResourceGroupName "ResourceGroup03" -AvailabilitySetName "AvailabilitySet17"

```

```PowerShell

Get-AzVMSize -ResourceGroupName "ResourceGroup03" -VMName "VirtualMachine12"

```