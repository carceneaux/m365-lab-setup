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
Write-Host "Importing user list....$($users.count) users found!"

# Looping through users
foreach ($user in $users) {
    Write-Host "Setting password for: $($user.UserPrincipalName)"
    try {
        # Retrieving user
        $current = Get-AzureAdUser | Where-Object { $_.UserPrincipalName -like $user.UserPrincipalName }
        if ($current){ 
            # Setting user password
            Set-AzureADUserPassword -ObjectID $current.ObjectID -Password $SecurePass
        } else {
            Write-Warning "User - $($user.UserPrincipalName) - not found!"
            throw
        }
    } catch {
        Write-Error "Unable to change password for: $($user.UserPrincipalName)"
    }
}

#### keeping admin separate in case a different password is specified in the future ####
# Set Admin Password
Write-Host "Setting password for: MOD Administrator"
try {
    # Retrieving user
    $current = Get-AzureAdUser | Where-Object { $_.DisplayName -eq 'MOD Administrator' }
    if ($current){ 
        # Setting user password
        Set-AzureADUserPassword -ObjectID $current.ObjectID -Password $SecurePass
    } else {
        Write-Warning "User - MOD Administrator - not found!"
        throw
    }
} catch {
    Write-Error "Unable to change password for: MOD Administrator"
}

# Disconnecting from Azure
Disconnect-AzureAD
