#Basic script to view stopped services on a system
$Computername = Read-host 'Enter name of host'

$StoppedService = get-service -ComputerName $Computername   |
                         Where-Object -Property Status -eq 'Stopped'

Write-Output $StoppedService
