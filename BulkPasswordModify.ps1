# This Script is used to modify the password of all demo users in the Microsoft Customer Digital Experience (CDX) environment assigning 'Veeam123!' as the PW.

Write-Host "Installing required Azure PowerShell module: AzureAd"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Find-PackageProvider -Name Nuget -ForceBootstrap -IncludeDependencies -Force | Out-Null
# Determine if AzureAd module is already present
if ( -not(Get-Module -ListAvailable -Name AzureAd)) {
    Install-Module -Name AzureAD -SkipPublisherCheck -Force -ErrorAction Stop
    Write-Host "AzureAD module installed successfully" -ForegroundColor Green
}
else {
    Write-Host "AzureAD module already present" -ForegroundColor Green
}

# Connecting to Azure
Connect-AzureAD

# Setting password variable
$Password = "Veeam123!"
$SecurePass = $Password | ConvertTo-SecureString -AsPlainText -Force

# Importing user list
Import-Csv "M365DemoUsers.csv"

# Looping through users
foreach ($user in $users) {
    # Set user password
    Get-AzureAdUser | where-object { $_.DisplayName.SubString(0, 7) -eq 'Student' } | Set-AzureADUserPassword -ObjectID $_.ObjectID -Password $SecurePass
}

# Set Admin Password
Get-AzureAdUser | where-object { $_.DisplayName -eq 'MOD Administrator' } | foreach { Set-AzureADUserPassword -ObjectID $_.ObjectID -Password $SecurePass }
