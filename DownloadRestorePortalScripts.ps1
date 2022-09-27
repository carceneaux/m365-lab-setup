# Downloads restore portal scripts

# Deletes restore portal scripts folder in case it already exists
Remove-Item "C:\Users\Administrator\Desktop\Restore Portal Scripts" -Recurse

# Change director to Administrator's desktop
Set-Location -Path "C:\Users\Administrator\Desktop"

# Downloading VeeamHub PowerShell repository
Invoke-WebRequest "https://codeload.github.com/VeeamHub/powershell/zip/master" -OutFile "scripts.zip"

# Unzipping archive
Expand-Archive -Path "scripts.zip" -DestinationPath "Restore Portal Scripts"
Remove-Item "scripts.zip"

# Moving relevant items and deleting the rest
Move-Item "Restore Portal Scripts\powershell-master\VB365-RestorePortalSetup\*.ps1" "Restore Portal Scripts"
Remove-Item "Restore Portal Scripts\powershell-master\" -Recurse