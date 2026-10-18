<#
.SYNOPSIS
    Reports locked-out, disabled and inactive user accounts and exports them to CSV.
.PARAMETER InactiveDays
    Number of days without sign-in before an account counts as inactive.
.PARAMETER Unlock
    Unlocks every locked-out account after reporting.
.EXAMPLE
    .\account-audit.ps1 -InactiveDays 90 -OutputFolder C:\Reports
#>
param(
    [int]$InactiveDays = 90,
    [string]$OutputFolder = ".",
    [switch]$Unlock
)

Import-Module ActiveDirectory
$stamp = Get-Date -Format "yyyyMMdd-HHmm"

$locked   = Search-ADAccount -LockedOut -UsersOnly
$disabled = Search-ADAccount -AccountDisabled -UsersOnly
$inactive = Search-ADAccount -AccountInactive -UsersOnly -TimeSpan ([TimeSpan]::FromDays($InactiveDays))

$report = @(
    $locked   | Select-Object @{n='Status';e={'LockedOut'}}, Name, SamAccountName, LastLogonDate, DistinguishedName
    $disabled | Select-Object @{n='Status';e={'Disabled'}},  Name, SamAccountName, LastLogonDate, DistinguishedName
    $inactive | Select-Object @{n='Status';e={"Inactive>${InactiveDays}d"}}, Name, SamAccountName, LastLogonDate, DistinguishedName
)

$path = Join-Path $OutputFolder "account-audit-$stamp.csv"
$report | Export-Csv -Path $path -NoTypeInformation
Write-Host ("Locked: {0}  Disabled: {1}  Inactive: {2}  ->  {3}" -f @($locked).Count, @($disabled).Count, @($inactive).Count, $path)

if ($Unlock -and $locked) {
    $locked | Unlock-ADAccount
    Write-Host "Unlocked $(@($locked).Count) account(s)."
}
