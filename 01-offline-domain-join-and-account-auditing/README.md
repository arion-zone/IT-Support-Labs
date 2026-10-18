# 01 – Offline Domain Join & Account Auditing

**Windows Server · Active Directory · PowerShell**

## Scenario

A company is building a server for a site that has no network path to a domain controller yet. It must arrive already joined to `corp.example.com`. At the same time the helpdesk wants better control over account security: lock out password-guessing attempts, find locked and stale accounts quickly, and limit who may sign in to servers locally or over RDP.

## Design

```text
 DC01 (corp.example.com)                 SRV01 (no line-of-sight to DC)
 ──────────────────────                  ──────────────────────────────
 1. djoin /provision  ──► odj-blob.txt ──►  2. djoin /requestODJ
    (creates computer account)  (USB / share)  (applies join offline)
                                             3. reboot → domain member
```

## What I Practised

- Pre-creating a computer account and join blob with `djoin /provision`
- Applying the blob on the target with `djoin /requestODJ`, with no DC contact needed
- Cleaning up stale computer objects before re-provisioning
- Setting an **account lockout policy** and checking it from a client
- Finding **locked**, **disabled** and **inactive** accounts with `Search-ADAccount`, and unlocking them
- Restricting **Allow log on locally** and **Allow log on through Remote Desktop Services**

## Why It Matters

| Real-world situation | Technique |
|---|---|
| Building devices at HQ for remote or offline sites | Offline Domain Join |
| "I'm locked out" tickets | `Search-ADAccount -LockedOut \| Unlock-ADAccount` |
| Access reviews / leaver clean-up | Disabled and inactive account reports |
| Limiting who can RDP to servers | User Rights Assignment + Remote Desktop Users |

## Files

| File | Description |
|---|---|
| [`runbook.md`](runbook.md) | Step-by-step procedure |
| [`scripts/offline-domain-join.cmd`](scripts/offline-domain-join.cmd) | djoin provisioning and apply |
| [`scripts/account-audit.ps1`](scripts/account-audit.ps1) | Locked, disabled and inactive account report |
| [`troubleshooting.md`](troubleshooting.md) | Common failures and fixes |

## What I Learned

- An offline join has two halves, **provision** (on a DC) and **apply** (on the target), and only takes effect after a reboot.
- The join blob contains the machine account password, so treat it like a credential.
- RDP access needs **both** the user right and membership of Remote Desktop Users.
- PowerShell account reports are much faster than browsing ADUC, and you can schedule them.
