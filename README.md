# IT Support Labs

A hands-on portfolio of Windows Server, Active Directory and Cisco networking projects for **IT Support** and **Junior System Administrator** work.

Each project is a scenario a real organisation might face. For each one I give the design, the reasoning behind it, a step-by-step runbook, reusable PowerShell, and notes on what tends to go wrong and how to fix it.

---

## Projects

### [Enterprise Network Labs](Enterprise-Network-Labs/)

| # | Project | What it covers |
|---|---------|----------------|
| 01 | [Offline Domain Join & Account Auditing](Enterprise-Network-Labs/01-offline-domain-join-and-account-auditing/) | `djoin.exe` provisioning, lockout policy, finding locked/disabled/stale accounts, logon and RDP rights |
| 02 | [DC Deployment with IFM & a Read-Only DC](Enterprise-Network-Labs/02-dc-deployment-ifm-and-rodc/) | Install From Media, adding DCs, RODC deployment, Password Replication Policy |
| 03 | [Multi-Domain Forest & Group Policy](Enterprise-Network-Labs/03-multi-domain-forest-and-group-policy/) | Forest/child-domain design, Server Core RODC, OU structure, Software Restriction GPOs, `gpresult` troubleshooting |

### [Network Technologies Labs](Network-Technologies-Labs/)

| # | Project | What it covers |
|---|---------|----------------|
| 01 | [Multi-Building Campus Network](Network-Technologies-Labs/01-campus-vlan-hsrp-nat/) | VLSM, VLANs & trunks, Layer 3 switching, HSRP redundancy, RIPv2, NAT overload |
| 02 | [IPv6 Migration with NAT-PT](Network-Technologies-Labs/02-ipv6-dual-stack-ospf-nat-pt/) | IPv6 subnet planning, OSPFv2 + OSPFv3, IPv6↔IPv4 translation |

Each project folder contains:

| File | Purpose |
|---|---|
| `README.md` | Scenario, design, skills and lessons learned |
| `lab_summary.md` | Walkthrough of my lab build with screenshots |
| `screenshots/` | Evidence from my lab environment |
| `runbook.md` | Step-by-step procedure I can follow (or hand to a colleague) |
| `scripts/` or `configs/` | PowerShell / IOS used, with placeholder names and documentation addresses |
| `troubleshooting.md` | Common failures and how to fix them |

---

## Environment

- **Hypervisor:** Hyper-V (Windows labs)
- **Network simulation:** Cisco Packet Tracer (networking labs)
- **Servers:** Windows Server 2016 (Desktop Experience and Server Core)
- **Client:** Windows 10 Enterprise
- **Example names:** `corp.example.com`, `DC01`, `DC02`, `RODC01`, `SRV01`, `CLIENT01`, all generic placeholders

---

## Skills Demonstrated

- **Active Directory:** AD DS installation, forest and child-domain design, IFM, RODC, Password Replication Policy
- **Identity & access:** users, groups and OUs, privileged group membership, account lockout, logon rights, RDP access
- **Group Policy:** GPMC, Software Restriction Policies, GPO linking and scope, `gpupdate`, `gpresult`
- **Cisco networking:** VLSM, VLANs/802.1Q, inter-VLAN routing, HSRP, RIPv2, OSPFv2/OSPFv3, NAT/PAT, IPv6, NAT-PT
- **PowerShell & CLI:** `Install-ADDS*`, `Search-ADAccount`, `Unlock-ADAccount`, `djoin`, `ntdsutil`
- **Documentation:** runbooks and troubleshooting notes written for other technicians

---

## About This Portfolio

I learned these skills through university study and hands-on practice. The write-ups, runbooks, scripts and troubleshooting notes are my own. The screenshots come from my own lab environment, with student, course and other personal identifiers blurred. The repo does **not** contain submitted reports, assessment briefs, marking criteria or course materials.
