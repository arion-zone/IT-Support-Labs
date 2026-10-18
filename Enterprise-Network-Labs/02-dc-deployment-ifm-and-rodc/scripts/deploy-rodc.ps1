<#
.SYNOPSIS
    Promotes a server to a Read-Only DC and configures its Password Replication Policy.
    Run section 1 on the new RODC, and sections 2-3 on a writable DC.
#>
param(
    [string]$Domain     = "corp.example.com",
    [string]$Site       = "Branch",
    [string]$Rodc       = "RODC01",
    [string]$AllowGroup = "Branch-Users",
    [string[]]$Members  = @("user1", "user2", "CLIENT01$")
)

# --- 1. Promote (on the RODC) -------------------------------------------
# Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
# Install-ADDSDomainController -DomainName $Domain -ReadOnlyReplica -SiteName $Site `
#     -InstallDns -Credential (Get-Credential)

# --- 2. Password Replication Policy (on a writable DC) ------------------
Import-Module ActiveDirectory

if (-not (Get-ADGroup -Filter "Name -eq '$AllowGroup'")) {
    New-ADGroup -Name $AllowGroup -GroupScope Global -GroupCategory Security
}
Add-ADGroupMember -Identity $AllowGroup -Members $Members

Add-ADDomainControllerPasswordReplicationPolicy -Identity $Rodc -AllowedList $AllowGroup

# --- 3. Prepopulate and report --------------------------------------------
foreach ($m in $Members) {
    Sync-ADObject -Object (Get-ADObject -Filter "SamAccountName -eq '$m'") `
        -Source (Get-ADDomainController -Discover -Writable).HostName -Destination $Rodc -PasswordOnly
}

Get-ADDomainControllerPasswordReplicationPolicyUsage -Identity $Rodc -RevealedAccounts |
    Select-Object Name, ObjectClass
