# Troubleshooting – Offline Domain Join & Account Auditing

| Symptom | Likely cause | Fix |
|---|---|---|
| `djoin /provision` fails with *account already exists* | Stale computer object with the same name | Delete the old object in ADUC, or add `/reuse` |
| `djoin /requestODJ` fails with *Access is denied* | CMD not running elevated | Run CMD as Administrator and use `/windowspath %SystemRoot% /localos` |
| Machine still in a workgroup after `requestODJ` | Not rebooted yet | The join only applies at the next boot, so restart |
| Domain sign-in fails after the join: *trust relationship failed* | Machine password mismatch from an older join | Re-provision, or run `Test-ComputerSecureChannel -Repair` |
| Lockout policy doesn't apply | Policy set in an OU-level GPO | Domain account policies only apply from a **domain-linked** GPO |
| `Search-ADAccount` not recognised | AD PowerShell module missing | Install RSAT AD tools, then `Import-Module ActiveDirectory` |
| User can't RDP even though they're in the GPO right | Not in **Remote Desktop Users** (or vice versa) | They need both, then `gpupdate /force` |
| UAC prompt when changing user rights | Standard user session | Use an admin account, or run as administrator |
