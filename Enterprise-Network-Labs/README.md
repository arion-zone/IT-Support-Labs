# Enterprise Network Labs

Windows Server and Active Directory labs built in a Hyper-V environment of five VMs: domain controllers, member servers, a Server Core box and a Windows 10 client.

| # | Lab | Highlights |
|---|-----|-----------|
| 01 | [Offline Domain Join & Account Auditing](01-offline-domain-join-and-account-auditing/) | `djoin.exe`, lockout policy, `Search-ADAccount`, logon and RDP rights |
| 02 | [DC Deployment with IFM & a Read-Only DC](02-dc-deployment-ifm-and-rodc/) | `ntdsutil` IFM, extra DC, RODC, Password Replication Policy |
| 03 | [Multi-Domain Forest & Group Policy](03-multi-domain-forest-and-group-policy/) | Forest + child domains, Server Core RODC, OUs, Software Restriction GPOs, `gpresult` |

## Lab Environment

| VM | Role |
|----|------|
| PLABDC01 | Forest root domain controller |
| PLABDM01 | Additional DC / child-domain DC |
| PLABDCORE01 | Read-Only DC (Server Core) |
| PLABSA01 | Member server → RODC / child-domain DC |
| PLABWIN10 | Domain-joined Windows 10 client |

Each lab has a `lab_summary.md` showing what I built, with a screenshot for every step, and a `runbook.md` that rewrites the procedure with generic names so it can be reused anywhere.
