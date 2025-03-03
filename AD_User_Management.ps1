# Active Directory User Management Script
# Created by: [Your Name] - Service Desk Analyst
# Description: This script automates AD tasks like user creation, password reset, and group management.

# Import Active Directory module (Ensure RSAT is installed)
Import-Module ActiveDirectory

# Function to create a new user
function New-ADUserAccount {
    param(
        [string]$FirstName,
        [string]$LastName,
        [string]$Department
    )

    # Generate username
    $Username = "$FirstName.$LastName".ToLower()
    $Email = "$Username@example.com"
    $OU = "OU=Employees,DC=example,DC=com"
    $InitialPassword = "TempP@ssw0rd"

    # Create AD User
    New-ADUser -Name "$FirstName $LastName" `
               -GivenName $FirstName `
               -Surname $LastName `
               -SamAccountName $Username `
               -UserPrincipalName $Email `
               -Path $OU `
               -AccountPassword (ConvertTo-SecureString $InitialPassword -AsPlainText -Force) `
               -Enabled $true `
               -ChangePasswordAtLogon $true

    Write-Host "User $Username created successfully with email $Email."
}

# Function to reset a user password
function Reset-ADUserPassword {
    param(
        [string]$Username,
        [string]$NewPassword
    )

    Set-ADAccountPassword -Identity $Username -NewPassword (ConvertTo-SecureString $NewPassword -AsPlainText -Force) -Reset
    Write-Host "Password for $Username has been reset."
}

# Function to add user to a group
function Add-UserToGroup {
    param(
        [string]$Username,
        [string]$GroupName
    )

    Add-ADGroupMember -Identity $GroupName -Members $Username
    Write-Host "$Username added to $GroupName."
}

# Function to remove user from a group
function Remove-UserFromGroup {
    param(
        [string]$Username,
        [string]$GroupName
    )

    Remove-ADGroupMember -Identity $GroupName -Members $Username -Confirm:$false
    Write-Host "$Username removed from $GroupName."
}

# Logging actions
$LogFile = "C:\Scripts\AD_User_Management.log"

function Log-Action {
    param([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp - $Message" | Out-File -Append -FilePath $LogFile
}

# Sample Execution (Uncomment to run)
# New-ADUserAccount -FirstName "John" -LastName "Doe" -Department "IT"
# Reset-ADUserPassword -Username "John.Doe" -NewPassword "NewSecureP@ss1"
# Add-UserToGroup -Username "John.Doe" -GroupName "IT Support"
# Remove-UserFromGroup -Username "John.Doe" -GroupName "IT Support"

Write-Host "Active Directory User Management Script by [Your Name] - Ready to execute!"