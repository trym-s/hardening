# 1.7.3 Ensure GDM disable-user-list option is enabled (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
GDM is the GNOME Display Manager which handles graphical login for GNOME based systems.

The `disable-user-list` option controls if a list of users is displayed on the login screen.

## Rationale
Displaying the user list eliminates half of the Userid/Password equation that an unauthorized person would need to log on.

## Audit
Run the following command to verify that the disable-user-list option is enabled:
```bash
gsettings get org.gnome.login-screen disable-user-list
```
Expected output: `true`

## Remediation

### Option 1: If a user profile exists
Run the following command to enable disable-user-list:
```bash
gsettings set org.gnome.login-screen disable-user-list true
```

**Note:**
- gsettings commands MUST be done from a command window on a graphical desktop or an error will be returned
- The system must be restarted after all gsettings configurations have been set

### Option 2: If a user profile does not exist

1. Create or edit the gdm profile in `/etc/dconf/profile/gdm`:
```
user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults
```

2. Create a gdm keyfile for machine-wide settings in `/etc/dconf/db/gdm.d/00-login-screen`:
```
[org/gnome/login-screen]
# Do not show the user list
disable-user-list=true
```

3. Update the system databases:
```bash
dconf update
```

**Note:** When the user profile is created or changed, the user will need to log out and log in again before the changes will be applied.

## Default Value
`false`

## References
1. https://help.gnome.org/admin/system-admin-guide/stable/login-userlist-disable.html.en
2. NIST SP 800-53 Rev. 5: CM-1, CM-2, CM-6, CM-7, IA-5

## Additional Information
If a different GUI login service is in use and required on the system, consult your documentation to disable displaying the user list.

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1078, T1078.001, T1078.002, T1078.003, T1087, T1087.001, T1087.002 | TA0007 | M1028 |
