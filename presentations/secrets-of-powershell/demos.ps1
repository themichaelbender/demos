#Secrets of PowerShell demos

#Region Demo01: Create an obscene number of active directory users
.\userdemo\Create-ADUserFromCSV-splatt.ps1
Get-ADUser -Filter * -SearchBase "OU=Users,OU=CompanyOU,DC=Company,DC=pri" | FT
Get-ADUser -Filter * -SearchBase "OU=Users,OU=CompanyOU,DC=Company,DC=pri" | Measure-Object
Get-ADUser -Filter * -SearchBase "OU=Users,OU=CompanyOU,DC=Company,DC=pri" | Remove-ADUser
Get-ADUser -Filter * -SearchBase "OU=Users,OU=CompanyOU,DC=Company,DC=pri" | Measure-Object
#Endregion

#Region Demo - Finding Info in the Shell
    # _about
    # help *...*
    get-command -Name *Fire*
    get-command -Name get-*Fire*
    get-command -Name get-NetFire*
    help Get-NetFirewallRule 
    Help get-NetFirewallRule -examples
    Get-NetFirewallRule | gm
    Get-NetFirewallRule
    Get-NetFirewallRule -Name *Remote* 
    Get-NetFirewallRule -Name *RemoteDesktop* 
    Get-NetFirewallRule -Name *RemoteDesktop* | FT
    Get-NetFirewallRule -Name *RemoteDesktop* | Set-NetFirewallRule -Enabled 'True' -Whatif
    Get-NetFirewallRule -Name *RemoteDesktop* | FT
    #Endregion

#Region - Elevating Commands for privelege
    $credential = Get-Credential
#Endregion

#Region Demo - Objects
    get-service | GM

    #Call a Method 
#Endregion

#Region Demo AD
    #Filtering
    #Searchbase
    #Properties
    Get-ADObject -Filter {(Name -like "WarrenG*") -and (ObjectClass -eq "user")}

    To get all user objects who have not logged on since January 1, 2007, use the following commands:
$logonDate = New-Object System.DateTime(2007, 1, 1)
Get-ADUser -filter { lastLogon -le $logonDate } -SearchBase "ou=Madison,OU=CompanyOU,DC=Company,DC=Pri"

https://docs.microsoft.com/en-us/powershell/module/activedirectory/?view=winserver2012-ps
#Endregion

#Region Demo Filter Left | Format Right

    #Demo1 Filter on DC01
    #Demo2 Filter at Client
#Endregion

#Region Demo Splatting
#EndRegion

#Region Remoting
# Implicit Remoting
    #PowerShell Core
    $comp = 'DC01'
    $cred = (Get-Credential)

    $Remoting 
    Invoke-Command -ComputerName DC01 -Credential $credential -ScriptBlock {
        Get-aduser -Properties * -Filter * 
    }
    }

    $PS = New-PSSession -ComputerName "DC01" -Credential $cred
    Invoke-Command -ComputerName $comp -Credential $cred -ScriptBlock {
            Import-Module -Name ActiveDirectory

    }

    Export-PSSession -Session $PS -OutputModule RemAD -AllowClobber
    Directory: C:\Users

    Remove-PSSession

    Import-Module -Name 

    https://4sysops.com/archives/using-implicit-powershell-remoting-to-import-remote-modules/
#Endregion

    #Region Using VS Code
ctrl+shift+P

SS
#Endregion

#Region Console Tours
# Windows PowerShell Tour
# PowerShell Core Tour
#Endregion