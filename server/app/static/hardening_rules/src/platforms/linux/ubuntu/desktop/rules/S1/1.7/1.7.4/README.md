# 1.7.4 Ensure GDM screen locks when the user is idle (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
GNOME Desktop Manager can make the screen lock automatically whenever the user is idle for some amount of time.

## Rationale
Setting a lock-out value reduces the window of opportunity for unauthorized user access to another user's session that has been left unattended.

## Audit
Run the following commands to verify that the screen locks when the user is idle:
```bash
gsettings get org.gnome.desktop.screensaver lock-delay
```
Expected output: `uint32 5` (5 seconds or less)

```bash
gsettings get org.gnome.desktop.session idle-delay
```
Expected output: `uint32 900` (900 seconds/15 minutes or less, not 0)

**Notes:**
- `lock-delay=uint32 {n}` - should be 5 seconds or less and follow local site policy
- `idle-delay=uint32 {n}` - should be 900 seconds (15 minutes) or less, not 0 (disabled) and follow local site policy

## Remediation

### Option 1: If a user profile already exists
Run the following commands to enable screen locks when the user is idle:
```bash
gsettings set org.gnome.desktop.screensaver lock-delay 5
gsettings set org.gnome.desktop.session idle-delay 900
```

**Note:**
- gsettings commands MUST be done from a command window on a graphical desktop
- The system must be restarted after all gsettings configurations have been set

### Option 2: If a user profile does not exist

1. Create or edit the user profile in `/etc/dconf/profile/user`:
```
user-db:user
system-db:local
```

2. Create the directory if needed:
```bash
mkdir -p /etc/dconf/db/local.d/
```

3. Create the key file `/etc/dconf/db/local.d/00-screensaver`:
```
[org/gnome/desktop/session]
# Number of seconds of inactivity before the screen goes blank
idle-delay=uint32 900

[org/gnome/desktop/screensaver]
# Number of seconds after the screen is blank before locking the screen
lock-delay=uint32 5
```

4. Update the system databases:
```bash
dconf update
```

5. Users must log out and back in again before the system-wide settings take effect.

## References
1. https://help.gnome.org/admin/system-admin-guide/stable/desktop-lockscreen.html.en

## CIS Controls

| Controls Version | Control | IG 1 | IG 2 | IG 3 |
|------------------|---------|------|------|------|
| v8 | 4.3 Configure Automatic Session Locking on Enterprise Assets | ● | ● | ● |
| v7 | 16.11 Lock Workstation Sessions After Inactivity | ● | ● | ● |

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1461 | TA0027 | M1012 |
