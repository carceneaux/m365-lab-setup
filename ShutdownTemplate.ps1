# welcome message
Clear-Host
Write-Host "ShutdownTemplate.ps1" -ForegroundColor Green
Write-Host "-----------------------"
Write-Host "WARNING: This script powers off this computer." -ForegroundColor Yellow
Write-Host "If you do not want to do this, please quit." -ForegroundColor Yellow
Timeout /NoBreak 10

# Making sure most recent restore portal scripts are present
.\DownloadRestorePortalScripts.ps1

# Clearing PowerShell history
Remove-Item (Get-PSReadlineOption).HistorySavePath

# Empty Recycle Bin
Clear-RecycleBin -Force

# Shuts down computer
Stop-Computer