#Updated: Michael Bender 3/2/2019
#Original Scipt by Sean Kearney  https://gallery.technet.microsoft.com/scriptcenter/9d7b6833-438e-4e1c-a4e7-cabcc17ec03b
#Note this script requires two files called GivenName.CSV and Surname.CSV 
# They are simple text files 
# Content of "GivenName.CSV" 
#  
# GivenName 
# John 
# Mary 
# Sue 
# Joey 
#  
# (And whatever First names you can cough up) ;) 
#  
# Content of "Surname.CSV" 
# 
# Smith 
# Jones 
# Wilson 
# Kearney 
#  
# (And again whatever Last names you can type in) 
#  
# These files have to exist in a folder called "C:\Powershell Scripts" 
# BUT You CAN edit this to meet your needs 
# 
# It generates a CSV file called DOMAINUSERS.CSV in the 
# C:\Powershell Scripts folder which is suitable for  
# Importing into Demo Active Directory environments 
# 
# The $totalnames is how many names it will generate. 
# Again you can edit this to meet your needs 
#  
# Import list of Last names from Simple Text file 

[cmdletbinding()]
Param (
    [Parameter()]$path='./DomainUsers.csv',
    [parameter()][int32]$Totalnames= 10,
    [parameter()]$domainname= "company.pri",
    [Parameter()][bool]$Enabled = $false
 ) 

$Surname=import-csv -Path c:\scripts\Surname.csv 
 
# Import list of First names Simple Text file 
 
$GivenName=import-csv -Path C:\scripts\GivenName.csv
 
# How many names to generate 
 
#$totalnames= Read-Host 'Enter total number of users'

# Where would you like the file

 

# the Header for our new CSV file 
 
$firstline='GivenName,Surname,Department,SamAccountName,UserPrincipalName,City,Enabled,ChangePasswordAtLogon'

# Department

$department= import-csv -path C:\scripts\department.csv
 
#City
$city = import-csv -Path c:\scripts\city.csv
#Other AD Variables
$changePassword = $true

#Domain
$DC=@($domainname.split("."))
$TLD = $dc[1]
$DOM = $dc[0]
$DN = "OU=Users,OU=CompanyOU,DC=$Dom,DC=$TLD"
# Create a file called “DomainUsers.csv”  
 
# By the way, the script is DEAD simple.  It doesn’t check for the existence 
 
# of the file before hand.   So play with it how you want :) 
Remove-Item $path -force -ErrorAction SilentlyContinue

Add-content -path $path -value $firstline
 
# Go through and Generate some names 
Write-Output "Creating $TotalNames Active Directory Users to .\DomainUsers.csv. Please Hold " -
foreach ( $namecounter in 1..$totalnames )  
{ 
 
    # Pick a random first and Last name 
    $Surnamenumber=(get-random -min 0 -max (($Surname.Surname)))  
    $GivenNamenumber=(get-random -min 0 -max (($GivenName.GivenName)))  
    $departmentnumber=(get-random -min 0 -max (($department.department))) 
    $citynumber = (get-random -min 0 -max (($city.City))) 
    $SamAccountName = $GivenNamenumber+$Surnamenumber
    $UserPrincipalName =$SamAccountName+'@'+$domainname

    $FakeName=($GivenNamenumber+','+$Surnamenumber+','+$departmentnumber+','+$SamAccountName+','+$UserPrincipalName+','+$citynumber+','+$Enabled+','+$changePassword) 
 
    # Echo the New name to the Screen 
    write-Output -InputObject $namecounter # $FakeName

    # and write to the File 
    add-content -path $path -value $fakename  
} 
 Write-Ouput "Done!!!"
 Notepad .\DomainUsers.csv