# Using Get-AzVMSize

Finding the right virtual machine for you needs can be difficult especially with all of the options available. And chances are, new options are coming day so you may need to regularly check the VMs available. Sure, you could do this through the GUI, but using PowerShell makes it quick and easy to see all of the VM sizes so you can get to building.

## General use

```PowerShell

Get-AzVMSize

```

### Finding Specific Types

Let's say you need to find out what sizes of VMs are available in a specific region, say East US, include 8 cores only.

```PowerShell

Get-AzVMSize -Location EastUS | Where NumberOfCores -EQ '8'`

```

Now you want to refine the list even further to include VM types that have a maximum data disk count (meaning the number a data disks that can be attached to the VM) of 16.

```PowerShell

Get-AzVMSize -Location EastUS | Where {($_.NumberOfCores -EQ '8') -And ($_.MaxDataDiskCount -eq '16')}

```

You'll notice that I used an **And** statment with Where (aka Where-Object) so that the objects in the pipeline need to meet both conditions: Number of Cores equal to 8 AND maximum data disk count equal to 16. Each conditions is contained with a parenthetical block (), compared based on the AND statement, and contained with curly brackets "{}". This technique is needed whenever comparing more than one condition.

## Addition Options

Let's say you want to know what size of VMs are available with a specific Availability set in a Resource group. 

```PowerShell

Get-AzVMSize -ResourceGroupName "ResourceGroup03" -AvailabilitySetName "AvailabilitySet17"

```

Or maybe you just want to see what the size if a particular VM, and you don't want to look in  the portal. Easy. Simply call the respective VMName and ResourceGroupName parameters for the target, and you have your answer.

```PowerShell

Get-AzVMSize -ResourceGroupName "ResourceGroup03" -VMName "VirtualMachine12"

```

Do you have a list of VMs in a CSV file? No Problem. 

```PowerShell
#Try
Get-AzVm... | Get-AzVMSize

$VMs = Import-CSV -FilePath <CSV>
Foreach($VM in $VMs) {

    Get-AzVMSize -ResourceGroupName $VM.ResourceGroupName -VMName $VM.VMName

}
```