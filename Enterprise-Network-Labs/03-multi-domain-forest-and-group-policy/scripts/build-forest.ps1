<#
.SYNOPSIS
    Example commands for building a forest root, child domains and an RODC.
    Run each section on the server named in its heading. Each promotion reboots the server.
#>

# ===== DC01 : forest root ==================================================
# Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
# Import-Module ADDSDeployment
# Install-ADDSForest -DomainName "corp.example.com" -InstallDns

# ===== DC-NORTH : child domain =============================================
# Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
# Install-ADDSDomain -DomainType ChildDomain -NewDomainName north `
#     -ParentDomainName corp.example.com -InstallDns `
#     -Credential (Get-Credential CORP\Administrator)

# ===== DC-SOUTH : child domain =============================================
# Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
# Install-ADDSDomain -DomainType ChildDomain -NewDomainName south `
#     -ParentDomainName corp.example.com -InstallDns `
#     -Credential (Get-Credential CORP\Administrator)

# ===== RODC01 (Server Core) : read-only DC =================================
# Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
# Install-ADDSDomainController -DomainName corp.example.com -ReadOnlyReplica `
#     -InstallDns -Credential (Get-Credential CORP\Administrator)

# ===== Verification (any DC) ===============================================
Get-ADForest | Select-Object -ExpandProperty Domains
Get-ADDomainController -Filter * | Select-Object Name, Domain, IsReadOnly, IsGlobalCatalog
