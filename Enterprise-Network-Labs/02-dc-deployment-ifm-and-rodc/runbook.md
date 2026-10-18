# Runbook – DC Deployment with IFM & a Read-Only DC

> Example names: domain `corp.example.com`, existing DC `DC01`, new writable DC `DC02`, branch RODC `RODC01`, client `CLIENT01`, PRP group `Branch-Users`.

---

## Part A – Create IFM Media (on DC01)

```cmd
ntdsutil
activate instance ntds
ifm
create sysvol full C:\IFM
quit
quit
```
Expected: *IFM media created successfully in C:\IFM*. Copy the folder to DC02, or share it temporarily.

---

## Part B – Promote DC02 from Media

1. Install the role:
   ```powershell
   Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
   ```
2. **Server Manager → Promote this server to a domain controller**
   - *Add a domain controller to an existing domain* → `corp.example.com`
   - Keep **DNS server** and **Global Catalog** selected, and set the **DSRM** password
   - **Additional Options → Install from media** → `C:\IFM` (click **Verify**)
3. Review the prerequisites check → **Install**. The server reboots.

PowerShell equivalent:
```powershell
Install-ADDSDomainController -DomainName corp.example.com -InstallationMediaPath C:\IFM `
    -InstallDns -Credential (Get-Credential CORP\Administrator)
```

**Verify:** ADUC → Domain Controllers lists DC02. You can also run `repadmin /replsummary`.

---

## Part C – Promote RODC01

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Install-ADDSDomainController -DomainName corp.example.com `
    -ReadOnlyReplica -SiteName "Branch" -InstallDns `
    -Credential (Get-Credential CORP\Administrator)
```
Confirm the prompt and let it reboot. In ADUC the DC type should show **Read-only, DC**.

---

## Part D – Password Replication Policy

1. **Create the allow group:** ADUC → New → Group → `Branch-Users` (Global, Security). Add the branch users **and** their computers (e.g. `CLIENT01`).
2. **Allow it on the RODC:** ADUC → Domain Controllers → `RODC01` → Properties → **Password Replication Policy** → Add → `Branch-Users` → *Allow passwords for the account to replicate to this RODC*.
3. **Leave the deny defaults in place:** *Denied RODC Password Replication Group*, Administrators, Server/Backup/Account Operators.
4. **Prepopulate:** Advanced… → **Prepopulate Passwords** → add the users and computers.
5. **Check the cache:** Advanced… → *Accounts whose passwords are stored on this RODC*.

PowerShell equivalents are in [`scripts/deploy-rodc.ps1`](scripts/deploy-rodc.ps1).

---

## Part E – Test

Sign in to **CLIENT01** as a `Branch-Users` member. To prove the cache works, disconnect the hub DCs and sign in again.
