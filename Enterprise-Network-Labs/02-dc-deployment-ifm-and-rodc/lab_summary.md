# Lab Summary – Install From Media, RODC & Password Replication Policy

This lab extends `practicelabs.com` with more domain controllers. I promoted PLABDM01 to a writable DC from **Install From Media (IFM)** instead of replicating the full database over the network. I then promoted PLABSA01 to a **Read-Only Domain Controller (RODC)** and set its **Password Replication Policy** so only one group's passwords are cached on it.

> Screenshots are from my own lab environment. Identifying details (student/course identifiers and other people's names) are blurred.

---

## Exercise 1 – Install a Domain Controller from IFM

### Figure 1.1: Recording the Domain Controller Details
**Machine:** `PLABDC01`

Recorded the date and IP configuration of PLABDC01 (192.168.0.1) before starting.

![Figure 1.1 – Recording the Domain Controller Details](screenshots/fig-1.1-recording-the-domain-controller-details.jpg)

### Figure 1.2: Creating IFM Media with ntdsutil
**Machine:** `PLABDC01`

In `ntdsutil` I ran `activate instance ntds`, `ifm` and then `create sysvol full c:\IFM`. This takes a snapshot of the AD database and SYSVOL.

![Figure 1.2 – Creating IFM Media with ntdsutil](screenshots/fig-1.2-creating-ifm-media-with-ntdsutil.jpg)

### Figure 1.3: IFM Media Created
**Machine:** `PLABDC01`

ntdsutil copied the database, registry hives and SYSVOL policies and finished with *IFM media created successfully in c:\IFM*.

![Figure 1.3 – IFM Media Created](screenshots/fig-1.3-ifm-media-created.jpg)

### Figure 1.4: Mapping the DC Share from PLABDM01
**Machine:** `PLABDM01`

Mapped a drive from PLABDM01 to PLABDC01 so the new DC could reach the IFM folder.

![Figure 1.4 – Mapping the DC Share from PLABDM01](screenshots/fig-1.4-mapping-the-dc-share-from-plabdm01.jpg)

### Figure 1.5: Installing the AD DS Role
**Machine:** `PLABDM01`

`Add-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools` installed the AD DS binaries and management tools.

![Figure 1.5 – Installing the AD DS Role](screenshots/fig-1.5-installing-the-ad-ds-role.jpg)

### Figure 1.6: Domain Controller Options
**Machine:** `PLABDM01`

In the AD DS Configuration Wizard I kept DNS and Global Catalog selected and set the DSRM (Directory Services Restore Mode) password.

![Figure 1.6 – Domain Controller Options](screenshots/fig-1.6-domain-controller-options.jpg)

### Figure 1.7: Prerequisites Check
**Machine:** `PLABDM01`

Pointed the wizard at the IFM path. All prerequisite checks passed, apart from the usual warnings about cryptography defaults and DNS delegation.

![Figure 1.7 – Prerequisites Check](screenshots/fig-1.7-prerequisites-check.jpg)

### Figure 1.8: New DC in Active Directory
**Machine:** `PLABDM01`

After the reboot PLABDM01 is listed in the **Domain Controllers** OU next to PLABDC01.

![Figure 1.8 – New DC in Active Directory](screenshots/fig-1.8-new-dc-in-active-directory.jpg)

---

## Exercise 2 – Install a Read-Only Domain Controller

### Figure 2.1: Domain Controller Details
**Machine:** `PLABDC01`

Recorded the DC information again before starting the RODC exercise.

![Figure 2.1 – Domain Controller Details](screenshots/fig-2.1-domain-controller-details.jpg)

### Figure 2.2: Installing AD DS on PLABSA01
**Machine:** `PLABSA01`

Installed the AD DS role on PLABSA01 with `Add-WindowsFeature`.

![Figure 2.2 – Installing AD DS on PLABSA01](screenshots/fig-2.2-installing-ad-ds-on-plabsa01.jpg)

### Figure 2.3: Promoting to RODC with PowerShell
**Machine:** `PLABSA01`

`Install-ADDSDomainController -Credential (Get-Credential practicelabs\administrator) -DomainName practicelabs.com -ReadOnlyReplica` started the promotion and asked for domain admin credentials.

![Figure 2.3 – Promoting to RODC with PowerShell](screenshots/fig-2.3-promoting-to-rodc-with-powershell.jpg)

### Figure 2.4: Confirming the Promotion
**Machine:** `PLABSA01`

PowerShell warned that the server would become a domain controller and restart. I confirmed to continue.

![Figure 2.4 – Confirming the Promotion](screenshots/fig-2.4-confirming-the-promotion.jpg)

### Figure 2.5: RODC Listed in Active Directory
**Machine:** `PLABSA01`

The Domain Controllers OU now shows PLABSA01 with DC type **Read-only, DC**.

![Figure 2.5 – RODC Listed in Active Directory](screenshots/fig-2.5-rodc-listed-in-active-directory.jpg)

---

## Exercise 3 – Manage the Password Replication Policy

### Figure 3.1: Domain Controller Details
**Machine:** `PLABDC01`

Recorded the DC information for the third exercise.

![Figure 3.1 – Domain Controller Details](screenshots/fig-3.1-domain-controller-details.jpg)

### Figure 3.2: Allowed RODC Password Replication Group
**Machine:** `PLABDC01`

Checked the built-in **Allowed RODC Password Replication Group**. It has no members by default, so no passwords are cached on an RODC unless an admin allows it.

![Figure 3.2 – Allowed RODC Password Replication Group](screenshots/fig-3.2-allowed-rodc-password-replication-group.jpg)

### Figure 3.3: Creating the VPN Users Group
**Machine:** `PLABDC01`

Created a new global security group called **VPN Users**.

![Figure 3.3 – Creating the VPN Users Group](screenshots/fig-3.3-creating-the-vpn-users-group.jpg)

### Figure 3.4: Adding Members to VPN Users
**Machine:** `PLABDC01`

Added two test users and the workstation PLABWIN10 to the group.

![Figure 3.4 – Adding Members to VPN Users](screenshots/fig-3.4-adding-members-to-vpn-users.jpg)

### Figure 3.5: Allowing VPN Users on the RODC
**Machine:** `PLABDC01`

On PLABSA01's **Password Replication Policy** tab I added VPN Users and chose *Allow passwords for the account to replicate to this RODC*.

![Figure 3.5 – Allowing VPN Users on the RODC](screenshots/fig-3.5-allowing-vpn-users-on-the-rodc.jpg)

### Figure 3.6: Password Replication Policy Applied
**Machine:** `PLABDC01`

The policy list now shows VPN Users set to **Allow**. Built-in admin groups stay on **Deny**.

![Figure 3.6 – Password Replication Policy Applied](screenshots/fig-3.6-password-replication-policy-applied.jpg)

### Figure 3.7: Accounts Cached on the RODC (Before)
**Machine:** `PLABSA01`

Advanced Password Replication Policy showed which accounts had passwords stored on the RODC. Before prepopulating, only the RODC's own accounts were cached.

![Figure 3.7 – Accounts Cached on the RODC (Before)](screenshots/fig-3.7-accounts-cached-on-the-rodc-before.jpg)

### Figure 3.8: Prepopulating Passwords
**Machine:** `PLABSA01`

Used **Prepopulate Passwords** to push the VPN Users members' credentials to the RODC in advance. Those users can then sign in at the branch even if the WAN link is down.

![Figure 3.8 – Prepopulating Passwords](screenshots/fig-3.8-prepopulating-passwords.jpg)

### Figure 3.9: Verifying from the Writable DC
**Machine:** `PLABDC01`

Viewed the same report from PLABDC01. both test users and PLABWIN10 are now listed as cached.

![Figure 3.9 – Verifying from the Writable DC](screenshots/fig-3.9-verifying-from-the-writable-dc.jpg)

### Figure 3.10: Signing In from the Client
**Machine:** `PLABWIN10`

Signed in to PLABWIN10 as a VPN Users member to test a domain logon with the cached credentials.

![Figure 3.10 – Signing In from the Client](screenshots/fig-3.10-signing-in-from-the-client.jpg)

### Figure 3.11: Final Domain Controller Check
**Machine:** `PLABDC01`

Captured the final date and IP configuration.

![Figure 3.11 – Final Domain Controller Check](screenshots/fig-3.11-final-domain-controller-check.jpg)
