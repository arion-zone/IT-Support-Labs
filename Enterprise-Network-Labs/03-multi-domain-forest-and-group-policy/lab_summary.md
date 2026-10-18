# Lab Summary – Multi-Domain Active Directory Design & Group Policy

I designed and built an AD forest with a root domain in Melbourne, child domains for Auckland and Perth, and a Read-Only DC. I then managed it with OUs, users, group membership and two Group Policy Objects that block applications for specific users, and checked the results with `gpresult`.

> Screenshots are from my own lab environment. Identifying details (student/course identifiers and other people's names) are blurred.

---

## Task 1 – Active Directory Design

### Figure 1.1: PLABDC01 – Date & IP Configuration
**Machine:** `PLABDC01`

Ran `date; ipconfig` on the forest root DC (192.168.0.1).

![Figure 1.1 – PLABDC01 – Date & IP Configuration](screenshots/fig-1.1-plabdc01-date-ip-configuration.jpg)

### Figure 1.2: PLABDM01 – Date & IP Configuration
**Machine:** `PLABDM01`

Recorded the future Auckland child-domain DC (192.168.0.2).

![Figure 1.2 – PLABDM01 – Date & IP Configuration](screenshots/fig-1.2-plabdm01-date-ip-configuration.jpg)

### Figure 1.3: PLABDCORE01 – Date & IP Configuration
**Machine:** `PLABDCORE01`

Recorded the Server Core machine that would become the RODC (192.168.0.3).

![Figure 1.3 – PLABDCORE01 – Date & IP Configuration](screenshots/fig-1.3-plabdcore01-date-ip-configuration.jpg)

### Figure 1.4: PLABSA01 – Date & IP Configuration
**Machine:** `PLABSA01`

Recorded the future Perth child-domain DC (192.168.0.4).

![Figure 1.4 – PLABSA01 – Date & IP Configuration](screenshots/fig-1.4-plabsa01-date-ip-configuration.jpg)

### Figure 1.5: PLABWIN10 – Date & IP Configuration
**Machine:** `PLABWIN10`

Recorded the Windows 10 workstation (192.168.0.7).

![Figure 1.5 – PLABWIN10 – Date & IP Configuration](screenshots/fig-1.5-plabwin10-date-ip-configuration.jpg)

### Figure 1.6: Hyper-V Manager – All VMs Running
**Machine:** `Host`

All five VMs running in Hyper-V before the build started.

![Figure 1.6 – Hyper-V Manager – All VMs Running](screenshots/fig-1.6-hyper-v-manager-all-vms-running.jpg)

---

## Task 2 – Active Directory Installation

### Figure 2.1: Creating the Forest Root Domain
**Machine:** `PLABDC01`

`Install-ADDSForest -DomainName "PracticeLabs.com"` after installing the AD DS role created the forest root.

![Figure 2.1 – Creating the Forest Root Domain](screenshots/fig-2.1-creating-the-forest-root-domain.jpg)

### Figure 2.2: Creating the Auckland Child Domain
**Machine:** `PLABDM01`

`Install-ADDSDomain -DomainType ChildDomain -NewDomainName the AKL child domain -ParentDomainName PracticeLabs.com -InstallDNS` with Enterprise Admin credentials.

![Figure 2.2 – Creating the Auckland Child Domain](screenshots/fig-2.2-creating-the-auckland-child-domain.jpg)

### Figure 2.3: Creating the Perth Child Domain
**Machine:** `PLABSA01`

Ran the same `Install-ADDSDomain` command for **the PER child domain**.

![Figure 2.3 – Creating the Perth Child Domain](screenshots/fig-2.3-creating-the-perth-child-domain.jpg)

### Figure 2.4: Credential Prompt – PLABSA01
**Machine:** `PLABSA01`

Entered `practicelabs\administrator` credentials for the parent domain.

![Figure 2.4 – Credential Prompt – PLABSA01](screenshots/fig-2.4-credential-prompt-plabsa01.jpg)

### Figure 2.5: Promoting PLABDCORE01 to RODC
**Machine:** `PLABDCORE01`

On Server Core: `Install-ADDSDomainController -DomainName practicelabs.com -Credential (Get-Credential practicelabs\administrator) -ReadOnlyReplica`.

![Figure 2.5 – Promoting PLABDCORE01 to RODC](screenshots/fig-2.5-promoting-plabdcore01-to-rodc.jpg)

### Figure 2.6: Verifying Computers in the Root Domain
**Machine:** `PLABDC01`

ADUC on PLABDC01 lists the domain's computer accounts.

![Figure 2.6 – Verifying Computers in the Root Domain](screenshots/fig-2.6-verifying-computers-in-the-root-domain.jpg)

### Figure 2.7: Domain Controllers in the Root Domain
**Machine:** `PLABDC01`

PLABDC01 and the RODC PLABDCORE01 are in the Domain Controllers OU.

![Figure 2.7 – Domain Controllers in the Root Domain](screenshots/fig-2.7-domain-controllers-in-the-root-domain.jpg)

### Figure 2.8: Computers in the AKL child domain
**Machine:** `PLABDM01`

The Auckland child domain shows up in ADUC on PLABDM01.

![Figure 2.8 – Computers in the AKL child domain](screenshots/fig-2.8-computers-in-the-akl-child-domain.jpg)

### Figure 2.9: Computers in the PER child domain
**Machine:** `PLABSA01`

The Perth child domain shows up in ADUC on PLABSA01.

![Figure 2.9 – Computers in the PER child domain](screenshots/fig-2.9-computers-in-the-per-child-domain.jpg)

### Figure 2.10: Domain Controllers in AKL
**Machine:** `PLABDM01`

PLABDM01 is the DC for the AKL child domain.

![Figure 2.10 – Domain Controllers in AKL](screenshots/fig-2.10-domain-controllers-in-akl.jpg)

### Figure 2.11: Domain Controllers in PER
**Machine:** `PLABSA01`

PLABSA01 is the DC for the PER child domain.

![Figure 2.11 – Domain Controllers in PER](screenshots/fig-2.11-domain-controllers-in-per.jpg)

### Figure 2.12: Hyper-V Manager – All Systems Configured
**Machine:** `Host`

All VMs running after Task 2.

![Figure 2.12 – Hyper-V Manager – All Systems Configured](screenshots/fig-2.12-hyper-v-manager-all-systems-configured.jpg)

---

## Task 3A – User Accounts & Groups

### Figure 3.1: Creating the AZURE OU
**Machine:** `PLABDC01`

Created an Organizational Unit in ADUC (New → Organizational Unit).

![Figure 3.1 – Creating the AZURE OU](screenshots/fig-3.1-creating-the-azure-ou.jpg)

### Figure 3.2: OU Created
**Machine:** `PLABDC01`

The new OU appears under practicelabs.com. BLOCK was created the same way.

![Figure 3.2 – OU Created](screenshots/fig-3.2-ou-created.jpg)

### Figure 3.3: User Details – the standard test user
**Machine:** `PLABDC01`

Filled in the first name, last name and logon name.

![Figure 3.3 – User Details – the standard test user](screenshots/fig-3.3-user-details-the-standard-test-user.jpg)

### Figure 3.4: Password Options
**Machine:** `PLABDC01`

Set a temporary password and ticked **User must change password at next logon**.

![Figure 3.4 – Password Options](screenshots/fig-3.4-password-options.jpg)

### Figure 3.5: User Created in AZURE
**Machine:** `PLABDC01`

the standard test user is now in the AZURE OU.

![Figure 3.5 – User Created in AZURE](screenshots/fig-3.5-user-created-in-azure.jpg)

### Figure 3.6: Creating the admin test user in BLOCK
**Machine:** `PLABDC01`

Created a second user in the BLOCK OU.

![Figure 3.6 – Creating the admin test user in BLOCK](screenshots/fig-3.6-creating-the-admin-test-user-in-block.jpg)

### Figure 3.7: Setting 'Password never expires'
**Machine:** `PLABDC01`

Used a different password option for this account so the two users behave differently.

![Figure 3.7 – Setting 'Password never expires'](screenshots/fig-3.7-setting-password-never-expires.jpg)

### Figure 3.8: Adding the admin test user to Domain Admins
**Machine:** `PLABDC01`

Member Of → Add → **Domain Admins**.

![Figure 3.8 – Adding the admin test user to Domain Admins](screenshots/fig-3.8-adding-the-admin-test-user-to-domain-admins.jpg)

### Figure 3.9: Domain Admins Membership Confirmed
**Machine:** `PLABDC01`

The user now has domain admin rights.

![Figure 3.9 – Domain Admins Membership Confirmed](screenshots/fig-3.9-domain-admins-membership-confirmed.jpg)

### Figure 3.10: First Sign-In – the standard test user
**Machine:** `PLABWIN10`

Signed in on PLABWIN10 and was asked to change the password, as the account option requires.

![Figure 3.10 – First Sign-In – the standard test user](screenshots/fig-3.10-first-sign-in-the-standard-test-user.jpg)

### Figure 3.11: Password Changed
**Machine:** `PLABWIN10`

The password change succeeded.

![Figure 3.11 – Password Changed](screenshots/fig-3.11-password-changed.jpg)

### Figure 3.12: Sign-In – the admin test user
**Machine:** `PLABWIN10`

Signed in as the second user.

![Figure 3.12 – Sign-In – the admin test user](screenshots/fig-3.12-sign-in-the-admin-test-user.jpg)

### Figure 3.13: Successful Sign-In
**Machine:** `PLABWIN10`

Signed in to PLABWIN10 as the admin test user.

![Figure 3.13 – Successful Sign-In](screenshots/fig-3.13-successful-sign-in.jpg)

---

## Task 3B – Software Restriction via GPO

### Figure 4.1: Creating a GPO
**Machine:** `PLABDC01`

Opened `gpmc.msc` and created a new GPO.

![Figure 4.1 – Creating a GPO](screenshots/fig-4.1-creating-a-gpo.jpg)

### Figure 4.2: Group Policy Management Editor
**Machine:** `PLABDC01`

Opened the GPO for editing.

![Figure 4.2 – Group Policy Management Editor](screenshots/fig-4.2-group-policy-management-editor.jpg)

### Figure 4.3: Blocking Notepad with a Path Rule
**Machine:** `PLABDC01`

Under **Software Restriction Policies → Additional Rules** I added a path rule for `%SystemRoot%\System32\notepad.exe` with security level *Disallowed*.

![Figure 4.3 – Blocking Notepad with a Path Rule](screenshots/fig-4.3-blocking-notepad-with-a-path-rule.jpg)

### Figure 4.4: Linking the GPO to AZURE
**Machine:** `PLABDC01`

Right-clicked the AZURE OU → *Link an Existing GPO* so the policy only applies to users in that OU.

![Figure 4.4 – Linking the GPO to AZURE](screenshots/fig-4.4-linking-the-gpo-to-azure.jpg)

### Figure 4.5: GPO Linked Successfully
**Machine:** `PLABDC01`

The GPO now shows under the AZURE OU.

![Figure 4.5 – GPO Linked Successfully](screenshots/fig-4.5-gpo-linked-successfully.jpg)

### Figure 4.6: Notepad Blocked for the standard test user
**Machine:** `PLABWIN10`

Notepad is blocked for the AZURE user: *This app has been blocked by your system administrator*.

![Figure 4.6 – Notepad Blocked for the standard test user](screenshots/fig-4.6-notepad-blocked-for-the-standard-test-user.jpg)

### Figure 4.7: Notepad Allowed for the admin test user
**Machine:** `PLABWIN10`

The BLOCK OU user is outside the GPO's scope, so Notepad opens normally.

![Figure 4.7 – Notepad Allowed for the admin test user](screenshots/fig-4.7-notepad-allowed-for-the-admin-test-user.jpg)

---

## Task 3C – Application Control via GPO

### Figure 5.1: Blocking Microsoft Photos
**Machine:** `PLABDC01`

Added a second Software Restriction path rule pointing at the Microsoft Photos app folder under `C:\Program Files\WindowsApps\` with security level *Disallowed*.

![Figure 5.1 – Blocking Microsoft Photos](screenshots/fig-5.1-blocking-microsoft-photos.jpg)

### Figure 5.2: Refreshing Group Policy
**Machine:** `PLABWIN10`

Signed in as Administrator and ran `gpupdate /force`.

![Figure 5.2 – Refreshing Group Policy](screenshots/fig-5.2-refreshing-group-policy.jpg)

### Figure 5.3: Photos Blocked – the standard test user
**Machine:** `PLABWIN10`

Opening Microsoft Photos as the standard test user shows the *blocked by your system administrator* message.

![Figure 5.3 – Photos Blocked – the standard test user](screenshots/fig-5.3-photos-blocked-the-standard-test-user.jpg)

### Figure 5.4: Photos Blocked – the admin test user
**Machine:** `PLABWIN10`

Photos is blocked for the admin test user too, because this GPO applies more widely than the Notepad one.

![Figure 5.4 – Photos Blocked – the admin test user](screenshots/fig-5.4-photos-blocked-the-admin-test-user.jpg)

---

## Task 3D – Verifying GPO Results

### Figure 6.1: gpresult – the standard test user
**Machine:** `PLABWIN10`

`date; gpresult /r` lists the GPOs applied to the user and computer.

![Figure 6.1 – gpresult – the standard test user](screenshots/fig-6.1-gpresult-the-standard-test-user.jpg)

### Figure 6.2: gpresult – the admin test user
**Machine:** `PLABWIN10`

The same report for the second user.

![Figure 6.2 – gpresult – the admin test user](screenshots/fig-6.2-gpresult-the-admin-test-user.jpg)

### Figure 6.3: Final Hyper-V Check
**Machine:** `Host`

Final Hyper-V view with date/time and IP configuration.

![Figure 6.3 – Final Hyper-V Check](screenshots/fig-6.3-final-hyper-v-check.jpg)
