#Building a Parameterized Script

When I talk with people about PowerShell, one of the areas that challenges many new users is creating scripts. In a nutshell,
*A script is simply a file that contains commands you want to run*

A script doesn't need to be complex, have a bunch of logical constructs, or look like you need a CS degree. A script should be a tool that performs a single task like retrieving a specific set of information from a remote system.

To that end, I want to share a process for building a parameterized script so you can begin experimenting with building your own tools. For years, I have taught a process that works like this:

You start with a hard-coded command that runs on the PowerShell console, and returns the information you are looking for. Why start here? Because if it doesn't work as a single command in the console, then it won't work in a script.

Once I have a running command, I move it into VS Code, and begin creating variables for any pieces of information that I would input if I were to re-use the command. Things like the Computername parameter come to mind as well as credentials. Remember, variables are a way to story information for our commands, and they will become the basis for our script parameters.

Now, we want to make this script work like the commands we are use to using in PowerShell. Parameterizing a script allows the script to be run along with parameters and input values at time of execution instead of putting the values in the script, or using a technique like Read-Host to get input. Below is what that would look like for a script I created for demos called Show-StoppedServices.ps1 that retrieves the stopped services from remote systems.

```
.\Show-StoppedServices.ps1 -ComputerName DC01 -Verbose

```
Let's say I need to perform a task like retrieving the a few pieces of information from a number of remote services. In this task, I want to see the size of the virtual disks of all of my VMs in Azure in a specific resource group. 

To start out, I log into shell.azure.com to access my Azure resources. I issue the following command to see the size of the VHDs of all of my VMS in Azure.
```
((get-azvm -ResourceGroupName HBY20-asc-demo  ).StorageProfile).Datadisks

((get-azvm -ResourceGroupName $RSG  ).StorageProfile).OsDisk | Select-Object -Property Name,OSType,DiskSizeGB

```
As this is a fairly complicated one-liner, no one wants to type this so let's look at first creating variables for the command. Since we want the command to use a sprecific resource group, the -ResourceGroupName parameter should become a variable so let's try this:
```
PS >$RSG = 'HBY20-asc-demo'
PS >((get-azvm -ResourceGroupName $RSG  ).StorageProfile).OsDisk | Select-Object -Property Name,OSType,DiskSizeGB
```
So that produces exactly the data we are looking for so the next step is to parameterize this by adding the code into a script, and creating a parameter block. A Parameter block defines the parameters that a script uses. Below is a sample :
```
param (
    [Parameter(Mandatory=$true)]
    [string]
    $RSG                
)
((get-azvm -ResourceGroupName $RSG  ).StorageProfile).OsDisk | Select-Object -Property Name,OSType,DiskSizeGB
```
In the example above, I want to ensure that the script always gets the required input of the ResourceGroupName so I make the parameter manadatory. If the parameter is not included at execution, PowerShell will prompt for input before it executes.

This is a simple example of begin tool building and autmation in PowerShell.