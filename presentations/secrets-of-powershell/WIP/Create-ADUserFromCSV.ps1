#Create-ADUserFromCSV
#Requires .csv file

#UserSetup

    $SetPass = read-host -Prompt 'Enter Password' -assecurestring

    $Users =Import-CSV .\goodusers.csv

    $cred = Get-Credential

    $Cities = Import-Csv .\City.csv

    $Departments = Import-csv .\department.csv



#ForEach loop creates users from CSV file

    ForEach ($user in $users){ 
        $GivenName = $user.firstname
        $surname = $user.Lastname
        
        #Splatt
        $@ {
            -Credential $cred
            -Credential $cred 

            -Path $user.DistinguishedName
    
            -department $user.Department `
    
            -SamAccountName $user.SamAccountName
    
            -Name $user.Name
    
            -Surname $user.Surname
    
            -GivenName $user.GivenName
    
            -UserPrincipalName $GivenName+"."+$Surname+"@company.pri"
    
            -City $user.city
    
            -ChangePasswordAtLogon $False
    
            -AccountPassword $SetPass
    
            -Enabled $False -Verbose
        }
    New-ADUser `

        -Credential $cred `

        -Path $user.DistinguishedName `

        -department $user.Department `

        -SamAccountName $user.SamAccountName `

        -Name $user.Name `

        -Surname $user.Surname `

        -GivenName $user.GivenName `

        -UserPrincipalName $GivenName+"."+$Surname+"@company.pri"`

        -City $user.city `

        -ChangePasswordAtLogon $False `

        -AccountPassword $SetPass `

        -Enabled $False -Verbose

        
    $CN="Cn="+$USER.Name+","+$user.DistinguishedName

    Set-ADObject -Identity $CN -ProtectedFromAccidentalDeletion $False -Verbose
        }