Add-WindowsFeature Web-Server
Add-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $($env:computername)
$webservervalue = "Web Server: " + $($env:computername)
Add-Content -Path "C:\inetpub\wwwroot\default.htm" -Value $webservervalue
