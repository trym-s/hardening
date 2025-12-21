# 1.7.5 Ensure GDM screen locks cannot be overridden (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
GNOME Desktop Manager can lock down specific settings by using the lockdown mode in dconf to prevent users from changing specific settings.

To lock down a dconf key or subpath, create a locks subdirectory in the keyfile directory. The files inside this directory contain a list of keys or subpaths to lock. Just as with the keyfiles, you may add any number of files to this directory.

## Rationale
Setting a lock-out value reduces the window of opportunity for unauthorized user access to another user's session that has been left unattended.

Without locking down the system settings, user settings take precedence over the system settings.

## Audit
Run the following script to verify that the screen lock cannot be overridden:
```bash
#!/usr/bin/env bash
{
    a_output=() a_output2=()
    f_check_setting()
    {
        grep -Psrilq -- "^\h*$2\b" /etc/dconf/db/local.d/locks/* && \
        echo "- \"$3\" is locked" || echo "- \"$3\" is not locked or not set"
    }
    declare -A settings=(
        ["idle-delay"]="/org/gnome/desktop/session/idle-delay"
        ["lock-delay"]="/org/gnome/desktop/screensaver/lock-delay"
    )
    for setting in "${!settings[@]}"; do
        result=$(f_check_setting "$setting" "${settings[$setting]}" "$setting")
        if [[ $result == *"is not locked"* || $result == *"not set to false"* ]]; then
            a_output2+=("$result")
        else
            a_output+=("$result")
        fi
    done
    printf '%s\n' "" "- Audit Result:"
    if [ "${#a_output2[@]}" -gt 0 ]; then
        printf '%s\n' " ** FAIL **" " - Reason(s) for audit failure:" "${a_output2[@]}"
        [ "${#a_output[@]}" -gt 0 ] && printf '%s\n' "" "- Correctly set:" "${a_output[@]}"
    else
        printf '%s\n' " ** PASS **" "${a_output[@]}"
    fi
}
```

## Remediation

1. Create the file `/etc/dconf/db/local.d/locks/00-screensaver` with the following content:
```
# Lock desktop screensaver settings
/org/gnome/desktop/session/idle-delay
/org/gnome/desktop/screensaver/lock-delay
```

2. Update the system databases:
```bash
dconf update
```

**Note:**
- A user profile must exist in order to apply locks.
- Users must log out and back in again before the system-wide settings take effect.

## References
1. https://help.gnome.org/admin/system-admin-guide/stable/desktop-lockscreen.html.en
2. https://help.gnome.org/admin/system-admin-guide/stable/dconf-lockdown.html.en
3. NIST SP 800-53 Rev. 5: CM-11

## CIS Controls

| Controls Version | Control | IG 1 | IG 2 | IG 3 |
|------------------|---------|------|------|------|
| v8 | 4.3 Configure Automatic Session Locking on Enterprise Assets | ● | ● | ● |
| v7 | 16.11 Lock Workstation Sessions After Inactivity | ● | ● | ● |

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1456 | TA0027 | M1001 |
