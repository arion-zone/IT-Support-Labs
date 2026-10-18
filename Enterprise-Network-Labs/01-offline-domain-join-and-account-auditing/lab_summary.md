# Lab Summary – Offline Domain Join & Account Management

In this lab I removed a member server (PLABSA01) from the `practicelabs.com` domain and joined it back **offline** with `djoin.exe`, so the server never had to contact the domain controller during the join. In the second half I set up an account lockout policy, triggered a lockout from a Windows 10 client, then used PowerShell to find locked, disabled and inactive accounts. I finished by controlling who can sign in locally and over RDP.

> Screenshots are from my own lab environment. Identifying details (student/course identifiers and other people's names) are blurred.

---

## Exercise 1 – Offline Domain Join

### Figure 1.1: Recording the Domain Controller Details
**Machine:** `PLABDC01`

Ran `date; ipconfig` on PLABDC01 to capture the time and the DC's IP address (192.168.0.1) before making any changes. The DC is also the domain's DNS server, so this is the address every member must be able to reach.

![Figure 1.1 – Recording the Domain Controller Details](screenshots/fig-1.1-recording-the-domain-controller-details.jpg)

### Figure 1.2: Removing PLABSA01 from the Domain
**Machine:** `PLABSA01`

Used `Remove-Computer` to take PLABSA01 out of the domain, confirmed the prompt, then restarted with `shutdown /r /t 0`. This sets up the scenario of a machine that has to be rejoined.

![Figure 1.2 – Removing PLABSA01 from the Domain](screenshots/fig-1.2-removing-plabsa01-from-the-domain.jpg)

### Figure 1.3: Deleting the Stale Computer Object
**Machine:** `PLABDC01`

In Active Directory Users and Computers I deleted the old PLABSA01 object and accepted the *Confirm Subtree Deletion* warning. Removing the stale account avoids a name/SID conflict when the computer is provisioned again.

![Figure 1.3 – Deleting the Stale Computer Object](screenshots/fig-1.3-deleting-the-stale-computer-object.jpg)

### Figure 1.4: Provisioning the Computer Account with djoin
**Machine:** `PLABDC01`

`djoin /provision /domain practicelabs.com /machine plabsa01 /savefile c:\plabsa01.txt` created a new computer account in AD and wrote the domain-join blob (machine password, domain SID, DC details) to a text file.

![Figure 1.4 – Provisioning the Computer Account with djoin](screenshots/fig-1.4-provisioning-the-computer-account-with-djoin.jpg)

### Figure 1.5: Mapping a Drive to the Domain Controller
**Machine:** `PLABSA01`

From PLABSA01 I mapped drive **Z:** to the DC's administrative share so I could get the provisioning file onto the server.

![Figure 1.5 – Mapping a Drive to the Domain Controller](screenshots/fig-1.5-mapping-a-drive-to-the-domain-controller.jpg)

### Figure 1.6: Copying the Provisioning File
**Machine:** `PLABSA01`

Copied `plabsa01.txt` from the mapped drive to the local C: drive. In a real deployment this file could equally travel on a USB stick or an image.

![Figure 1.6 – Copying the Provisioning File](screenshots/fig-1.6-copying-the-provisioning-file.jpg)

### Figure 1.7: Applying the Offline Join
**Machine:** `PLABSA01`

`djoin /requestODJ /loadfile c:\plabsa01.txt /windowspath %SystemRoot% /localos` loaded the blob into the local Windows installation. The join takes effect at the next boot, so I restarted with `shutdown /r /t 0`.

![Figure 1.7 – Applying the Offline Join](screenshots/fig-1.7-applying-the-offline-join.jpg)

### Figure 1.8: Confirming the Join in AD
**Machine:** `PLABDC01`

After the reboot PLABSA01 appears again in the **Computers** container, so the offline join worked.

![Figure 1.8 – Confirming the Join in AD](screenshots/fig-1.8-confirming-the-join-in-ad.jpg)

---

## Exercise 2 – Locked, Disabled & Inactive Accounts

### Figure 2.1: Setting the Account Lockout Threshold
**Machine:** `PLABDC01`

In the Group Policy Management Editor I set **Account lockout threshold** to lock an account after a set number of invalid logon attempts. This is the standard defence against password guessing.

![Figure 2.1 – Setting the Account Lockout Threshold](screenshots/fig-2.1-setting-the-account-lockout-threshold.jpg)

### Figure 2.2: Triggering a Lockout on the Client
**Machine:** `PLABWIN10`

I typed the wrong password repeatedly on PLABWIN10 until Windows reported *the referenced account is currently locked out*. That shows the domain policy reached the client.

![Figure 2.2 – Triggering a Lockout on the Client](screenshots/fig-2.2-triggering-a-lockout-on-the-client.jpg)

### Figure 2.3: Finding and Unlocking Locked Accounts
**Machine:** `PLABDC01`

`Search-ADAccount -LockedOut` listed the locked users (two test users). Piping the result into `Unlock-ADAccount` unlocked them both, and a second search came back empty.

![Figure 2.3 – Finding and Unlocking Locked Accounts](screenshots/fig-2.3-finding-and-unlocking-locked-accounts.jpg)

### Figure 2.4: Listing Disabled Accounts
**Machine:** `PLABDC01`

`Search-ADAccount -AccountDisabled` returned the built-in disabled accounts (krbtgt, Guest, DefaultAccount).

![Figure 2.4 – Listing Disabled Accounts](screenshots/fig-2.4-listing-disabled-accounts.jpg)

### Figure 2.5: Disabled Accounts After Changes
**Machine:** `PLABDC01`

I disabled the two test users and ran the search again. They now appear in the list alongside the built-in accounts.

![Figure 2.5 – Disabled Accounts After Changes](screenshots/fig-2.5-disabled-accounts-after-changes.jpg)

### Figure 2.6: Listing Inactive Accounts
**Machine:** `PLABDC01`

`Search-ADAccount -AccountInactive -UsersOnly -TimeSpan 1.00:00:00 | ft name` listed users who had not signed in during the last day. This is a quick way to spot stale accounts during an audit.

![Figure 2.6 – Listing Inactive Accounts](screenshots/fig-2.6-listing-inactive-accounts.jpg)

### Figure 2.7: Inactive Accounts – Updated List
**Machine:** `PLABDC01`

Re-ran the inactive-account query to confirm the updated results.

![Figure 2.7 – Inactive Accounts – Updated List](screenshots/fig-2.7-inactive-accounts-updated-list.jpg)

### Figure 2.8: Reviewing 'Allow log on locally'
**Machine:** `PLABDC01`

Opened the **Allow log on locally** user right to see which groups (Administrators, Account/Backup/Print/Server Operators, Enterprise Domain Controllers) are allowed to sign in at the console.

![Figure 2.8 – Reviewing 'Allow log on locally'](screenshots/fig-2.8-reviewing-allow-log-on-locally.jpg)

### Figure 2.9: Granting 'Allow log on through Remote Desktop Services'
**Machine:** `PLABDC01`

Added **PRACTICELABS\Domain Admins** and **PRACTICELABS\GRMarketing** to the RDP logon right.

![Figure 2.9 – Granting 'Allow log on through Remote Desktop Services'](screenshots/fig-2.9-granting-allow-log-on-through-remote-desktop-servi.jpg)

### Figure 2.10: Adding a Group to Remote Desktop Users
**Machine:** `PLABDC01`

In System Properties → Remote, I added GRMarketing to **Remote Desktop Users**. The user right and the group membership are both needed before RDP access works.

![Figure 2.10 – Adding a Group to Remote Desktop Users](screenshots/fig-2.10-adding-a-group-to-remote-desktop-users.jpg)

### Figure 2.11: UAC Elevation Prompt
**Machine:** `PLABDC01`

User Account Control asked for administrator credentials before the change could be made, showing that changing logon rights needs elevated permissions.

![Figure 2.11 – UAC Elevation Prompt](screenshots/fig-2.11-uac-elevation-prompt.jpg)

### Figure 2.12: Final Domain Controller Check
**Machine:** `PLABDC01`

Captured `date; ipconfig` again at the end of the lab as a timestamped record.

![Figure 2.12 – Final Domain Controller Check](screenshots/fig-2.12-final-domain-controller-check.jpg)
