#Secrets of PowerShell demos

#Demo01: Create an obscene number of active directory users
.\userdemo\Create-ADUserFromCSV-splatt.ps1
Get-ADUser -Filter * -SearchBase "OU=Users,OU=CompanyOU,DC=Company,DC=pri" | FT
Get-ADUser -Filter * -SearchBase "OU=Users,OU=CompanyOU,DC=Company,DC=pri" | Measure-Object
Get-ADUser -Filter * -SearchBase "OU=Users,OU=CompanyOU,DC=Company,DC=pri" | Remove-ADUser
Get-ADUser -Filter * -SearchBase "OU=Users,OU=CompanyOU,DC=Company,DC=pri" | Measure-Object

#Demo
# Windows PowerShell Tour

# PowerShell Core Tour

# Demo - Customizing Shell

# Demo - Finding Info in the Shell
    # _about
    # help *...*

# Elevating Commands for privelege
    $credential = Get-Credential

# Demo - Objects
    get-service | GM

    #Call a Method 

    


# Demo AD
    #Filtering
    #Searchbase
    #Properties
    Get-ADObject -Filter {(Name -like "WarrenG*") -and (ObjectClass -eq "user")}

    To get all user objects who have not logged on since January 1, 2007, use the following commands:
$logonDate = New-Object System.DateTime(2007, 1, 1)
Get-ADUser -filter { lastLogon -le $logonDate } -SearchBase "ou=Madison,OU=CompanyOU,DC=Company,DC=Pri"

https://docs.microsoft.com/en-us/powershell/module/activedirectory/?view=winserver2012-ps

#Demo Filter Left | Format Right

    #Demo1 Filter on DC01
    #Demo2 Filter at Client

# Demo Splatting

# Implicit Remoting
    #PowerShell Core
    $Remoting 
    Invoke-Command -ComputerName DC01 -Credential $credential -ScriptBlock {
        Get-aduser -Properties * -Filter * 
    }
    }

# Using VS Code

# Building a Function in 10 minutes


