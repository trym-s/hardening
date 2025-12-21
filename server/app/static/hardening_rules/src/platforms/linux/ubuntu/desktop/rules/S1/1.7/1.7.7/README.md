# 1.7.7 Ensure GDM disabling automatic mounting of removable media is not overridden (Automated)

## Profile Applicability
- Level 1 - Server
- Level 2 - Workstation

## Description
By default GNOME automatically mounts removable media when inserted as a convenience to the user.

By using the lockdown mode in dconf, you can prevent users from changing specific settings. To lock down a dconf key or subpath, create a locks subdirectory in the keyfile directory. The files inside this directory contain a list of keys or subpaths to lock. Just as with the keyfiles, you may add any number of files to this directory.

## Rationale
With automounting enabled anyone with physical access could attach a USB drive or disc and have its contents available in system even if they lacked permissions to mount it themselves.

## Impact
The use of portable hard drives is very common for workstation users.

## Audit
Run the following script to verify automatic mounting of removable media is not overridden:
```bash
#!/usr/bin/env bash
{
    a_output=() a_output2=()
    check_setting()
    {
        grep -Psrilq "^\h*$1\h*=\h*false\b" /etc/dconf/db/local.d/locks/* 2> /dev/null && \
        echo "- \"$3\" is locked and set to false" || echo "- \"$3\" is not locked or not set to false"
    }
    declare -A settings=(
        ["automount"]="org/gnome/desktop/media-handling"
        ["automount-open"]="org/gnome/desktop/media-handling"
    )
    for setting in "${!settings[@]}"; do
        result=$(check_setting "$setting" "${settings[$setting]}" "$setting")
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

1. Create the file `/etc/dconf/db/local.d/locks/00-media-automount` with the following content:
```
# Lock automatic mounting settings
/org/gnome/desktop/media-handling/automount
/org/gnome/desktop/media-handling/automount-open
```

2. Update the system databases:
```bash
dconf update
```

**Note:**
- A user profile must exist in order to apply locks.
- Users must log out and back in again before the system-wide settings take effect.

## References
1. https://help.gnome.org/admin/system-admin-guide/stable/dconf-lockdown.html.en
2. NIST SP 800-53 Rev. 5: CM-1, CM-2, CM-6, CM-7, IA-5
3. https://manpages.ubuntu.com/manpages/trusty/man1/gsettings.1.html
4. https://access.redhat.com/solutions/20107

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1091, T1091.000 | TA0001, TA0008 | M1042 |
