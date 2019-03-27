# PowerShell Basics: Using Get-AzVMSize

Finding the right virtual machine for you needs can be difficult especially with all of the options available. New options seem to come around often so you may need to regularly check the VMs available within your Azure region. Sure, you could do this through the GUI, but using PowerShell makes it quick and easy to see all of the VM sizes so you can get to building your infrastructure.

That's where ```Get-AzVM``` comes in. It will help you determine the VM sizes you can deploy in specific regions, into availability sets, or what size a machine in your environment is running.

## General use
If you want to display all of the available VM sizes in a specific Azure region, you'd use the Location parameter to specify the region.

```PowerShell

Get-AzVMSize -Location WestUS

```

Let's say you want to know what size of VMs are available with a specific Availability set in a Resource group.

```PowerShell

Get-AzVMSize -ResourceGroupName "Az-Demo-RSG" -AvailabilitySetName "Az-Demo-AvailSet01"

```

Or maybe you just want to see what the size if a particular VM, and you don't want to look in  the portal. Easy. Simply call the respective VMName and ResourceGroupName parameters for the target, and you have your answer.

```PowerShell

Get-AzVMSize -ResourceGroupName "Az-Demo-RSG" -VMName "VM-Win-01"

```

## Getting More Granular Data

Now you need to find out what sizes of VMs are available in a specific region, say East US, include 8 cores only. By adding in a logical operator of ```-eq```, you can create more granular queries with your commands.

```PowerShell

PS Azure:\> Get-AzVMSize -Location EastUS | Where NumberOfCores -EQ '8'

Name                   NumberOfCores MemoryInMB MaxDataDiskCount OSDiskSizeInMB ResourceDiskSizeInMB
----                   ------------- ---------- ---------------- -------------- --------------------
Standard_B8ms                      8      32768               16        1047552                65536
Standard_DS4_v2                    8      28672               32        1047552                57344
Standard_DS13-2_v2                 8      57344               32        1047552               114688
Standard_DS13-4_v2                 8      57344               32        1047552               114688
Standard_DS13_v2                   8      57344               32        1047552               114688
Standard_DS4_v2_Promo              8      28672               32        1047552                57344
Standard_DS13_v2_Promo             8      57344               32        1047552               114688
Standard_F8s                       8      16384               32        1047552                32768
Standard_D8s_v3                    8      32768               16        1047552                65536
Standard_A4                        8      14336               16        1047552               619520
Standard_A7                        8      57344               16        1047552               619520
Basic_A4                           8      14336               16        1047552               245760
Standard_D4_v2                     8      28672               32        1047552               409600
Standard_D13_v2                    8      57344               32        1047552               409600
Standard_D4_v2_Promo               8      28672               32        1047552               409600
Standard_D13_v2_Promo              8      57344               32        1047552               409600
Standard_F8                        8      16384               32        1047552               131072
Standard_A8m_v2                    8      65536               16        1047552                81920
Standard_A8_v2                     8      16384               16        1047552                81920
Standard_D8_v3                     8      32768               16        1047552               204800
Standard_E8_v3                     8      65536               16        1047552               204800
Standard_E8-2s_v3                  8      65536               16        1047552               131072
Standard_E8-4s_v3                  8      65536               16        1047552               131072
Standard_E8s_v3                    8      65536               16        1047552               131072
Standard_H8                        8      57344               32        1047552              1024000
Standard_H8m                       8     114688               32        1047552              1024000
Standard_D4                        8      28672               32        1047552               409600
Standard_D13                       8      57344               32        1047552               409600
Standard_F8s_v2                    8      16384               16        1047552                65536
Standard_DS4                       8      28672               32        1047552                57344
Standard_DS13                      8      57344               32        1047552               114688
Standard_L8s_v2                    8      65536               16        1047552              1811981
Standard_A8                        8      57344               32        1047552               391168
Standard_A10                       8      57344               32        1047552               391168
Standard_M8-2ms                    8     224000                8        1047552               256000
Standard_M8-4ms                    8     224000                8        1047552               256000
Standard_M8ms                      8     224000                8        1047552               256000

```

In this case, we use ```Where``` (short for Where-Object) to filter the objects in the pipeline, and display only those VM sizes with a number of cores equal to eight. Depending on your use case you could use other logical operators like less than, greater than, or any of the other conditional options. For more information, ```help about_logical_operators``` in PowerShell, or refer to the [about_logical_operators docs](https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_logical_operators?WT.md_id=blog-techcommunity-mibender&view=powershell-6).

Now you want to refine the list even further to include VM types that have a maximum data disk count (meaning the number a data disks that can be attached to the VM) of 16.

```PowerShell

PS Azure:\> Get-AzVMSize -Location EastUS | Where {($_.NumberOfCores -EQ '8') -And ($_.MaxDataDiskCount -eq '16')}


Name              NumberOfCores MemoryInMB MaxDataDiskCount OSDiskSizeInMB ResourceDiskSizeInMB
----              ------------- ---------- ---------------- -------------- --------------------
Standard_B8ms                 8      32768               16        1047552                65536
Standard_D8s_v3               8      32768               16        1047552                65536
Standard_A4                   8      14336               16        1047552               619520
Standard_A7                   8      57344               16        1047552               619520
Basic_A4                      8      14336               16        1047552               245760
Standard_A8m_v2               8      65536               16        1047552                81920
Standard_A8_v2                8      16384               16        1047552                81920
Standard_D8_v3                8      32768               16        1047552               204800
Standard_E8_v3                8      65536               16        1047552               204800
Standard_E8-2s_v3             8      65536               16        1047552               131072
Standard_E8-4s_v3             8      65536               16        1047552               131072
Standard_E8s_v3               8      65536               16        1047552               131072
Standard_F8s_v2               8      16384               16        1047552                65536
Standard_L8s_v2               8      65536               16        1047552              1811981

```

You'll notice that I used a comparison operator of **And** with ```Where``` so that the objects in the pipeline need to meet both conditions: Number of Cores equal to 8 AND maximum data disk count equal to 16. Each condition is contained with a parenthetical block "()", compared based on the AND statement with curly brackets "{}". This technique is needed whenever comparing more than one condition.
For more information, you can run ```help about_comparison_operators``` in PowerShell, or refer to the [about_comparison_operators docs](https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comparison_operators??WT.md_id=blog-techcommunity-mibender&view=powershell-6)

And that's a quick lesson on using Get-AzVmSize to find VM sizes in PowerShell, and uses conditions to get more out of your commands.
