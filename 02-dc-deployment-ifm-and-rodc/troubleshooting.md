# Troubleshooting – IFM & RODC

| Symptom | Likely cause | Fix |
|---|---|---|
| `create sysvol full` fails: *directory not empty* | Target folder already holds files | Use an empty or new folder |
| Wizard rejects the IFM path | Media made on a different OS version or for a different domain | Recreate IFM on a DC running the same OS version |
| IFM promotion is still slow | Media is old, so there are many changes to replicate | Make fresh media just before promoting |
| RODC promotion: *no writable DC found* | DNS on the RODC points at the wrong server | Set DNS to a writable DC, then `ipconfig /flushdns` |
| Branch user can't sign in while the WAN is down | Password not cached (not allowed, or never prepopulated) | Add them to the allow group and **Prepopulate Passwords** |
| User is in the allow group but still not cached | They're also in a **deny** group (Deny wins) | Remove them from the privileged group, or accept the exclusion |
| Computer sign-in fails offline | Only the user was cached, not the computer | Add computer accounts to the allow group too |
| RODC lost or stolen | Cached secrets are exposed | Delete the RODC account in ADUC and choose *reset passwords* for the cached accounts |
