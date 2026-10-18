# Troubleshooting – Multi-Domain Forest & Group Policy

| Symptom | Likely cause | Fix |
|---|---|---|
| Child-domain promotion: *parent domain could not be contacted* | Server DNS points at itself or a public resolver | Set DNS to the forest-root DC, then `ipconfig /flushdns` |
| *Access denied* creating a child domain | Credential isn't an **Enterprise Admin** | Use `CORP\Administrator` (or another Enterprise Admins member) |
| RODC promotion stalls on Server Core | Time out of sync with the domain | `w32tm /resync`, and check the time source |
| GPO not applying to a user | GPO linked to an OU that doesn't contain the user | Check the link location and the user's OU |
| GPO applies to the wrong people | Linked too high (domain level) | Link it to the specific OU, or use security filtering |
| App still opens after `gpupdate` | SRP user settings need a new sign-in | Sign out and in again (or reboot), then run `gpresult /r` |
| Store app (Photos) not blocked | Path rule points at a classic `.exe` path | Point the rule at `C:\Program Files\WindowsApps\<package>*` |
| `gpresult` lists the GPO under *filtered out* | Security filtering or WMI filter excludes the user | Check the *Delegation*/*Scope* tabs in GPMC |
| New user can't sign in at all | *User must change password* + RDP/NLA sign-in | Sign in at the console first, or reset the password with the flag cleared |
