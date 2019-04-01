#PowerShell Basics: Viewing a function in PowerShell

If you've used PowerShell, you've probably used a variety of commands. PowerShell has two main types: cmdlets and functions. Cmdlets are compiled commands based on C# and .NET. Functions are commands built using PowerShell as the language. Because of this, functions provide a good learning opportunity into how PowerShell works, and how you might move to building your own tools with it.

To start down this road, viewing how a function is constructed

```PowerShell

get-command Help | select -ExpandProperty definition

```
With Get-Command, the Definition property specifies the PowerShell code that makes up a function. 

So for Help, the definition lists as follows:

```PowerShell

<#
.FORWARDHELPTARGETNAME Get-Help
.FORWARDHELPCATEGORY Cmdlet
#>
[CmdletBinding(DefaultParameterSetName='AllUsersView', HelpUri='https://go.microsoft.com/fwlink/?LinkID=113316')]
param(
    [Parameter(Position=0, ValueFromPipelineByPropertyName=$true)]
    [string]
    ${Name},

    [string]
    ${Path},

    [ValidateSet('Alias','Cmdlet','Provider','General','FAQ','Glossary','HelpFile','ScriptCommand','Function','Filter','ExternalScript','All','DefaultHelp','Workflow','DscResource','Class','Configuration')]
    [string[]]
    ${Category},

    [string[]]
    ${Component},

    [string[]]
    ${Functionality},

    [string[]]
    ${Role},

    [Parameter(ParameterSetName='DetailedView', Mandatory=$true)]
    [switch]
    ${Detailed},

    [Parameter(ParameterSetName='AllUsersView')]
    [switch]
    ${Full},

    [Parameter(ParameterSetName='Examples', Mandatory=$true)]
    [switch]
    ${Examples},

    [Parameter(ParameterSetName='Parameters', Mandatory=$true)]
    [string]
    ${Parameter},

    [Parameter(ParameterSetName='Online', Mandatory=$true)]
    [switch]
    ${Online},

    [Parameter(ParameterSetName='ShowWindow', Mandatory=$true)]
    [switch]
    ${ShowWindow})

    #Set the outputencoding to Console::OutputEncoding. More.com doesn't work well with Unicode.
    $outputEncoding=[System.Console]::OutputEncoding

```
