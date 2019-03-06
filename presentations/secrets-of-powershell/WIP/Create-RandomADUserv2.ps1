#Create-ADUserFromCSV
#Requires .csv file

#UserSetup

    $SetPass = read-host -Prompt 'Enter Password' -assecurestring

    $Users =Import-CSV .\DomainUsers.csv

    $cred = Get-Credential



#ForEach loop creates users from CSV file

    ForEach ($user in $users){ 

    New-ADUser `

        -Credential $cred `

        -Path $user.DistinguishedName `

        -department $user.Department `

        -SamAccountName $user.SamAccountName `

        -Name $user.Name `

        -Surname $user.Surname `

        -GivenName $user.GivenName `

        -UserPrincipalName $user.UserPrincipalName `

        -City $user.city `

        -ChangePasswordAtLogon $False `

        -AccountPassword $SetPass `

        -Enabled $False -Verbose

        
    $CN="Cn="+$USER.Name+","+$user.DistinguishedName

    Set-ADObject -Identity $CN -ProtectedFromAccidentalDeletion $False -Verbose
        }