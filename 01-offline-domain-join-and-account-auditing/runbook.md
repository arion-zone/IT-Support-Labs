# Runbook – Offline Domain Join & Account Auditing

> Example names: domain `corp.example.com`, domain controller `DC01`, target server `SRV01`, client `CLIENT01`.

---

## Part A – Offline Domain Join

### 1. Check the domain controller
On **DC01**, record the IP and DNS settings that members will rely on.
```powershell
date; ipconfig /all
```

### 2. (Re-joins only) Remove the old membership and object
On **SRV01**:
```powershell
Remove-Computer -Restart
```
On **DC01**: open **Active Directory Users and Computers** and delete the stale `SRV01` computer object (accept *Delete Subtree* if prompted). This avoids SID or name conflicts.

### 3. Provision the computer account
On **DC01** (elevated CMD):
```cmd
djoin /provision /domain corp.example.com /machine SRV01 /savefile C:\ODJ\SRV01-odj.txt
```
Expected: *Computer provisioning completed successfully.* The account now exists in AD.

### 4. Transfer the blob
Copy `SRV01-odj.txt` to SRV01 by USB, a build image or a temporary share. **Delete it afterwards**, because it contains the machine password.

### 5. Apply the join on the target
On **SRV01** (elevated CMD):
```cmd
djoin /requestODJ /loadfile C:\SRV01-odj.txt /windowspath %SystemRoot% /localos
shutdown /r /t 0
```

### 6. Verify
- On **DC01**, ADUC → Computers shows `SRV01`.
- On **SRV01**, `systeminfo | findstr /i domain` returns `corp.example.com`.

---

## Part B – Account Lockout Policy

1. Open `gpmc.msc` → edit the domain-level password/lockout GPO.
2. **Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies → Account Lockout Policy**
   - *Account lockout threshold:* e.g. 5 invalid attempts
   - *Account lockout duration* / *Reset counter after:* e.g. 15 minutes
3. Test: on **CLIENT01**, enter a wrong password until Windows reports the account is locked out.

---

## Part C – Account Auditing (PowerShell)

Run on **DC01** (or any machine with RSAT):
```powershell
# Locked-out users, then unlock them all
Search-ADAccount -LockedOut -UsersOnly | Select Name, SamAccountName
Search-ADAccount -LockedOut -UsersOnly | Unlock-ADAccount

# Disabled accounts
Search-ADAccount -AccountDisabled -UsersOnly | Select Name, DistinguishedName

# Users with no sign-in for 90 days
Search-ADAccount -AccountInactive -UsersOnly -TimeSpan 90.00:00:00 | Select Name, LastLogonDate
```
See [`scripts/account-audit.ps1`](scripts/account-audit.ps1) for a version that exports a CSV.

---

## Part D – Logon & RDP Rights

1. In the server-baseline GPO: **Security Settings → Local Policies → User Rights Assignment**
   - **Allow log on locally:** limit to Administrators and the operator groups you need
   - **Allow log on through Remote Desktop Services:** add e.g. `CORP\Server-RDP-Users`
2. On the server: **System Properties → Remote → Select Users**, then add the same group to **Remote Desktop Users**.
3. Run `gpupdate /force` and test RDP with a member and a non-member.
