##This will modify all users added to the CSV files listed below
##Verify the CSV files are in the correct location and named properly.

Write-Host "Installing required Azure PowerShell module: MSOnline"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Find-PackageProvider -Name Nuget -ForceBootstrap -IncludeDependencies -Force | Out-Null
# Determine if MSOnline module is already present
if ( -not(Get-Module -ListAvailable -Name MSOnline)) {
    Install-Module -Name MSOnline -SkipPublisherCheck -Force -ErrorAction Stop
    Write-Host "MSOnline module installed successfully" -ForegroundColor Green
}
else {
    Write-Host "MSOnline module already present" -ForegroundColor Green
}

Connect-MsolService


Import-Csv "M365DemoUsers.csv" | ForEach-Object { Set-MsolUser -UserPrincipalName $_.UserPrincipalName -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName }
Import-Csv "M365DemoUsers.csv" | ForEach-Object { Set-MsolUserPrincipalName -UserPrincipalName $_.UserPrincipalName -NewUserPrincipalName $_.NewUserPrincipalName }
