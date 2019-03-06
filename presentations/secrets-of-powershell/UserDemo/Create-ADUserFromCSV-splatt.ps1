# Create-ADUserFromCSV
# Requires .csv file

# UserSetup

    $SetPass = read-host -Prompt 'Enter Password' -assecurestring

    $Users =Import-CSV .\goodusers-short.csv

    $cred = Get-Credential

    $Cities = Import-Csv .\city.csv

    $Departments = Import-csv .\department.csv

# ForEach loop creates users from CSV file

    ForEach ($user in $users){ 
        $GivenName = $user.firstname
        $surname = $user.Lastname
        $Department = (get-random -min 0 -max (($Departments.Department)))
        $City = (get-random -min 0 -max (($cities)))
        $Sam = $surname.substring(0,1)
        $join = $GivenName,$surname
        #Splatt
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
    #$ADValues
    New-ADUser @ADValues -Verbose

        
    #$CN="Cn="+$USER.Name+","+$user.DistinguishedName

    #Set-ADObject -Identity $CN -ProtectedFromAccidentalDeletion $False -Verbose
        }