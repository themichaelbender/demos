Add-WindowsFeature Web-Server
New-Item -ItemType directory -Path "C:\storagefiles\"
$pdfvalue = "Just a PDF"
$txtvalue = "Just a doc"
Add-Content -Path "C:\storagefiles\demopdf.pdf" -Value $pdfvalue
Add-content -path "c:\storagefiles\demotxt.txt" -value $txtvalue
# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
