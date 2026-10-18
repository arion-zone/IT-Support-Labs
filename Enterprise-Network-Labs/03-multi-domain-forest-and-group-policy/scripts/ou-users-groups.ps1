<#
.SYNOPSIS
    Creates the Staff and IT-Admins OUs, one user in each, and grants the admin Domain Admins.
    Example names only. You will be prompted for the initial passwords.
#>
Import-Module ActiveDirectory
$domainDN = (Get-ADDomain).DistinguishedName

foreach ($ou in "Staff", "IT-Admins") {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'")) {
        New-ADOrganizationalUnit -Name $ou -Path $domainDN -ProtectedFromAccidentalDeletion $true
    }
}

# Standard user - must change password at first sign-in
New-ADUser -Name "John Smith" -SamAccountName jsmith -UserPrincipalName "jsmith@$((Get-ADDomain).DNSRoot)" `
    -Path "OU=Staff,$domainDN" -AccountPassword (Read-Host "Password for jsmith" -AsSecureString) `
    -ChangePasswordAtLogon $true -Enabled $true

# Admin account - password never expires
New-ADUser -Name "Alex Lee (Admin)" -SamAccountName admin.alee -UserPrincipalName "admin.alee@$((Get-ADDomain).DNSRoot)" `
    -Path "OU=IT-Admins,$domainDN" -AccountPassword (Read-Host "Password for admin.alee" -AsSecureString) `
    -PasswordNeverExpires $true -Enabled $true

Add-ADGroupMember -Identity "Domain Admins" -Members admin.alee

Get-ADUser -Filter * -SearchBase $domainDN -Properties MemberOf |
    Where-Object { $_.SamAccountName -in "jsmith", "admin.alee" } |
    Select-Object SamAccountName, DistinguishedName
