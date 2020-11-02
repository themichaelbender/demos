# Install AzCopy 
# Based on Script by Thomas Mauerer
# Reference: https://www.thomasmaurer.ch/2019/05/how-to-install-azcopy-for-azure-storage/#:~:text=Install%20AzCopy%20on%20Windows.%20To%20install%20AzCopy%20on,you%20can%20run%20the%20AzCopy%20command%20from%20anywhere.#:~:text=Install%20AzCopy%20on%20Windows.%20To%20install%20AzCopy%20on,you%20can%20run%20the%20AzCopy%20command%20from%20anywhere.


#Download AzCopy
Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile AzCopy.zip -UseBasicParsing
 
#Curl.exe option (Windows 10 Spring 2018 Update (or later))
curl.exe -L -o AzCopy.zip https://aka.ms/downloadazcopy-v10-windows
 
#Expand Archive
Expand-Archive ./AzCopy.zip ./AzCopy -Force
 
#Move AzCopy to the destination you want to store it
$dir = "C:\Users\info\AzCopy"
mkdir $dir
Get-ChildItem ./AzCopy/*/azcopy.exe | Move-Item -Destination "C:\Users\info\AzCopy\AzCopy.exe"
 
#Add your AzCopy path to the Windows environment PATH (C:\Users\thmaure\AzCopy in this example), e.g., using PowerShell:
$userenv = [System.Environment]::GetEnvironmentVariable("Path", "User")
[System.Environment]::SetEnvironmentVariable("PATH", $userenv + ";C:\Users\info\AzCopy", "User")