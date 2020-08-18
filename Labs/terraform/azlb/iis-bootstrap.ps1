Add-WindowsFeature Web-Server
$webservervalue = "Web Server: " + $($env:computername)
Add-Content -Path "C:\inetpub\wwwroot\default.htm" -Value $webservervalue
