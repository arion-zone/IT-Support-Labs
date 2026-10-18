# IT Support Labs

A hands-on portfolio of Windows Server and Active Directory projects for **IT Support** and **Junior System Administrator** work.

Each project is a scenario a real organisation might face. For each one I give the design, the reasoning behind it, a step-by-step runbook, reusable PowerShell, and notes on what tends to go wrong and how to fix it.

---

## Projects

| # | Project | What it covers |
|---|---------|----------------|
| 01 | [Offline Domain Join & Account Auditing](01-offline-domain-join-and-account-auditing/) | `djoin.exe` provisioning, lockout policy, finding locked/disabled/stale accounts, logon and RDP rights |
| 02 | [DC Deployment with IFM & a Read-Only DC](02-dc-deployment-ifm-and-rodc/) | Install From Media, adding DCs, RODC deployment, Password Replication Policy |
| 03 | [Multi-Domain Forest & Group Policy](03-multi-domain-forest-and-group-policy/) | Forest/child-domain design, Server Core RODC, OU structure, Software Restriction GPOs, `gpresult` troubleshooting |

Each project folder contains:

| File | Purpose |
|---|---|
| `README.md` | Scenario, design, skills and lessons learned |
| `runbook.md` | Step-by-step procedure I can follow (or hand to a colleague) |
| `scripts/` | PowerShell / CMD used, with placeholders instead of real names |
| `troubleshooting.md` | Common failures and how to fix them |

---

## Environment

- **Hypervisor:** Hyper-V
- **Servers:** Windows Server 2016 (Desktop Experience and Server Core)
- **Client:** Windows 10 Enterprise
- **Example names:** `corp.example.com`, `DC01`, `DC02`, `RODC01`, `SRV01`, `CLIENT01`, all generic placeholders

---

## Skills Demonstrated

- **Active Directory:** AD DS installation, forest and child-domain design, IFM, RODC, Password Replication Policy
- **Identity & access:** users, groups and OUs, privileged group membership, account lockout, logon rights, RDP access
- **Group Policy:** GPMC, Software Restriction Policies, GPO linking and scope, `gpupdate`, `gpresult`
- **PowerShell & CLI:** `Install-ADDS*`, `Search-ADAccount`, `Unlock-ADAccount`, `djoin`, `ntdsutil`
- **Documentation:** runbooks and troubleshooting notes written for other technicians

---

## About This Portfolio

I learned these skills through university study and hands-on practice. Everything here is my own write-up: the scenarios, runbooks, scripts and notes are written from scratch with generic example names. The repo contains **no** coursework submissions, assessment tasks, marking criteria, course materials or third-party lab content.
