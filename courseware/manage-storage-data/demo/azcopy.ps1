# Using AzCopy in PowerShell 7

# Note: If you wish to run any of the commands below using a SAS key, you will need to provide one.
# Note: You will need to modify the storage endpoints below with the paths to the respective storage accounts, BlobStorage, And FileStorage created in your Azure subscription.

#Add your AzCopy path to the Windows environment PATH with PowerShell
    $userenv = [System.Environment]::GetEnvironmentVariable("Path", "User")
    [System.Environment]::SetEnvironmentVariable("PATH", $userenv + ";C:\demos\azcopy", "User")

    cd c:\demos

    AzCopy | more

    azcopy list -h

# Using Shared Authentication Signature (SAS) key w/ AzCopy for 

# Error command due to expired SAS key
    azcopy list "https://sablobstorage0001.blob.core.windows.net/?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-10-17T03:47:10Z&st=2020-10-15T19:47:10Z&spr=https&sig=KiBapm%2BOVZ6QC72VrNQybpPxsuiC68OOwy9SdQ%2F9rLY%3D"

# Functional command
    azcopy list "https://sablobstorage0001.blob.core.windows.net/?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-11-07T01:08:26Z&st=2020-10-29T16:08:26Z&spr=https&sig=h%2BvoHE3NmUdBwjxKkpmMACyCmgt6PuTD9UC2YNBQyjU%3D"

    dir

# Copy Local file to blobexport container in sablobstorage0001 storage account

# Error command due to missing container name in URI
    azcopy copy c:/demos/file002.txt "https://sablobstorage0001.file.core.windows.net/?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-11-07T01:08:26Z&st=2020-10-29T16:08:26Z&spr=https&sig=h%2BvoHE3NmUdBwjxKkpmMACyCmgt6PuTD9UC2YNBQyjU%3D"

# Copy and List
    azcopy copy c:/demos/file002.txt "https://sablobstorage0001.blob.core.windows.net/blobexport/?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-11-07T01:08:26Z&st=2020-10-29T16:08:26Z&spr=https&sig=h%2BvoHE3NmUdBwjxKkpmMACyCmgt6PuTD9UC2YNBQyjU%3D"
    azcopy list "https://sablobstorage0001.blob.core.windows.net/?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-11-07T01:08:26Z&st=2020-10-29T16:08:26Z&spr=https&sig=h%2BvoHE3NmUdBwjxKkpmMACyCmgt6PuTD9UC2YNBQyjU%3D"

# View File Share in Storage Account
    azcopy list "https://sablobstorage0001.file.core.windows.net/?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-11-07T01:08:26Z&st=2020-10-29T16:08:26Z&spr=https&sig=h%2BvoHE3NmUdBwjxKkpmMACyCmgt6PuTD9UC2YNBQyjU%3D"

    azcopy copy c:/demos/azcopy.exe "https://sablobstorage0001.file.core.windows.net/demofiles/?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-11-07T01:08:26Z&st=2020-10-29T16:08:26Z&spr=https&sig=h%2BvoHE3NmUdBwjxKkpmMACyCmgt6PuTD9UC2YNBQyjU%3D" --recursive

# View in Azure Portal

# Working with Azure AD Authentication
# Open Private Edge Browser Window to https://microsoft.com/devicelogin

    azcopy login

    azcopy list "https://sablobstorage0001.blob.core.windows.net/"

#Copy to Container
    azcopy list "https://satargetstorage001.blob.core.windows.net/"	

#error command missing SAS token in source location URI
    azcopy copy "https://sablobstorage0001.blob.core.windows.net/blobexport/" --recursive "https://satargetstorage001.blob.core.windows.net/blob/"

# Copy files between storage accounts
# Creates container called blob and copies 3 files to satargetstorage001 storage account

    azcopy make "https://satargetstorage001.blob.core.windows.net/blob"

    azcopy copy "https://sablobstorage0001.blob.core.windows.net/blobexport?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-11-07T01:08:26Z&st=2020-10-29T16:08:26Z&spr=https&sig=h%2BvoHE3NmUdBwjxKkpmMACyCmgt6PuTD9UC2YNBQyjU%3D" --recursive "https://satargetstorage001.blob.core.windows.net/blob"

    AzCopy list "https://satargetstorage001.blob.core.windows.net/"

    azcopy remove "https://satargetstorage001.blob.core.windows.net/blob" --recursive

    azcopy list "https://satargetstorage001.blob.core.windows.net/"	


