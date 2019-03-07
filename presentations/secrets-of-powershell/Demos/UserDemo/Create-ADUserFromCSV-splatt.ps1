# Create-ADUserFromCSV
# Requires .csv file

# UserSetup
# Set Password, Credentials, and ingest data for use
$SetPass = read-host -Prompt 'Enter Password' -assecurestring

$Users =Import-CSV .\users.csv

$cred = Get-Credential

$Cities = Import-Csv .\city.csv

$Departments = Import-csv .\department.csv

# ForEach loop creates users from CSV file

ForEach ($user in $users){ 
    $GivenName = $user.firstname
    $surname = $user.Lastname
    $Department = (get-random -min 0 -max (($Departments.Department)))
    $City = (get-random -min 0 -max (($cities)))
    $join = $GivenName,$surname
    
    #Splatt for New-ADUser parameters

    $ADValues = @{
        Credential = $cred
        
        Path = "OU=Users,OU=CompanyOU,DC=Company,DC=pri"

        department = $Department `

        SamAccountName = $join -join ""

        Name = $GivenName+" "+$surname

        Surname = $surname

        GivenName = $GivenName

        UserPrincipalName = $GivenName+"."+$Surname+"@company.pri"

        City = $City

        ChangePasswordAtLogon = $False

        AccountPassword = $SetPass

        Enabled = $False
    } 

    # 
    New-ADUser @ADValues -Verbose
  
}