#Get-ServiStatus.ps1 - Script displays the status of services running on a specified machine

#Creates a mandatory parameter for Computername and for Service Status

Param (
    [Parameter(Mandatory=$true)]
     $Computername,
    [Parameter(Mandatory=$true)]$ServiceStatus
)

#Creates a variable for Get-Service Objects
#As it holds multiple objects, referred to as an array
$Services = Get-Service -ComputerName $Computername

#Create empty array to store objects in loop
$Array = @()

#Use foreach construct to perform actions on each object in $Services
Foreach ($service in $services) {
    
    #Use if-else construct for decision making
    # use += to add each object into $array array
    if ($ServiceStatus -eq 'all') {
        $Array += $service
    }
    Else {
        $array += $service | Where-Object Status -EQ $ServiceStatus
       
    }
}
$Array = $Array | sort-object -Property Status
$Array