# Runbook – Multi-Domain Forest & Group Policy

> Example names: forest root `corp.example.com` (DC01), child domains `north` (DC-NORTH) and `south` (DC-SOUTH), Server Core RODC `RODC01`, client `CLIENT01`.

---

## Part A – Baseline

On every VM, record the time and network settings, and make sure each server's DNS points at DC01 before you promote anything.
```powershell
date; ipconfig /all
```

---

## Part B – Forest Root (DC01)

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -DomainName "corp.example.com" -InstallDns
```
The server reboots as the first DC in the forest.

---

## Part C – Child Domains (DC-NORTH, DC-SOUTH)

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Install-ADDSDomain -DomainType ChildDomain `
    -NewDomainName north `
    -ParentDomainName corp.example.com `
    -InstallDns `
    -Credential (Get-Credential CORP\Administrator)
```
Repeat on DC-SOUTH with `-NewDomainName south`. The credential must be an **Enterprise Admin** in the forest root.

---

## Part D – RODC on Server Core (RODC01)

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSDomainController -DomainName corp.example.com `
    -ReadOnlyReplica -InstallDns `
    -Credential (Get-Credential CORP\Administrator)
```

**Verify the forest:**
- ADUC on each domain → **Domain Controllers** and **Computers**
- `Get-ADForest | Select -Expand Domains` should list all three domains
- `Get-ADDomainController -Filter * | Select Name, Domain, IsReadOnly`

---

## Part E – OUs, Users & Groups

1. ADUC → `corp.example.com` → New → Organizational Unit: **Staff**, **IT-Admins**
2. **Staff** → New → User `jsmith` → tick *User must change password at next logon*
3. **IT-Admins** → New → User `admin.alee` → tick *Password never expires* (service-desk admin account)
4. `admin.alee` → Member Of → Add → **Domain Admins**
5. Test both sign-ins on CLIENT01. `jsmith` should be asked to change their password.

Script version: [`scripts/ou-users-groups.ps1`](scripts/ou-users-groups.ps1)

---

## Part F – Block Unapproved Apps (Software Restriction Policies)

1. `gpmc.msc` → **Group Policy Objects** → New → `Block-Unapproved-Apps` → Edit
2. **User Configuration → Policies → Windows Settings → Security Settings → Software Restriction Policies** → *New Software Restriction Policies*
3. **Additional Rules → New Path Rule**
   - `%SystemRoot%\System32\notepad.exe` → **Disallowed**
   - `C:\Program Files\WindowsApps\Microsoft.Windows.Photos_*` → **Disallowed**
4. Right-click the **Staff** OU → **Link an Existing GPO** → `Block-Unapproved-Apps`
5. On CLIENT01: `gpupdate /force`, then sign out and back in

**Expected:** `jsmith` sees *This app has been blocked by your system administrator*. `admin.alee` (IT-Admins OU) can open both apps.

> In production I'd use **AppLocker** or **WDAC** instead of SRP. The scoping principle is the same.

---

## Part G – Verify with gpresult

On CLIENT01, signed in as each user:
```powershell
date; gpresult /r
gpresult /h C:\Temp\gp-report.html   # full HTML report
```
Check **Applied Group Policy Objects** under *User Settings*: `Block-Unapproved-Apps` should appear for `jsmith` only.
