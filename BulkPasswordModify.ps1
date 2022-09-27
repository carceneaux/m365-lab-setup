# This Script is used to modify the password of all demo users in the Microsoft Customer Digital Experience (CDX) environment assigning 'Veeam123!' as the PW.

# Note: The M365DemoUsers.csv must be in the same folder as this script.

Write-Host "Installing required PowerShell module: AzureAd"
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
$users = Import-Csv "M365DemoUsers.csv"

# Looping through users
foreach ($user in $users) {
    # Retrieving user
    $current = Get-AzureAdUser | Where-Object { $_.UserPrincipalName -like $user.UserPrincipalName }
    # Setting user password
    Set-AzureADUserPassword -ObjectID $current.ObjectID -Password $SecurePass
}

# Set Admin Password
$current = Get-AzureAdUser | Where-Object { $_.DisplayName -eq 'MOD Administrator' } | Set-AzureADUserPassword -ObjectID $_.ObjectID -Password $SecurePass

# Disconnecting from Azure
Disconnect-AzureAD
