# 1.7.9 Ensure GDM autorun-never is not overridden (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The autorun-never setting allows the GNOME Desktop Display Manager to disable autorun through GDM.

By using the lockdown mode in dconf, you can prevent users from changing specific settings.

To lock down a dconf key or subpath, create a locks subdirectory in the keyfile directory. The files inside this directory contain a list of keys or subpaths to lock. Just as with the keyfiles, you may add any number of files to this directory.

## Rationale
Malware on removable media may take advantage of Autorun features when the media is inserted into a system and execute.

## Audit
Run the following script to verify that autorun-never=true cannot be overridden:
```bash
#!/usr/bin/env bash
{
    check_setting() {
        grep -Psrilq "^\h*$1\b" /etc/dconf/db/local.d/locks/* 2> /dev/null && \
        echo "- \"$1\" is locked" || echo "- \"$1\" is not locked"
    }
    
    declare -A settings=(["autorun-never"]="org/gnome/desktop/media-handling")
    
    l_output=() l_output2=()
    for setting in "${!settings[@]}"; do
        result=$(check_setting "/org/gnome/desktop/media-handling/$setting")
        l_output+=("$result")
        if [[ $result == *"is not locked"* ]]; then
            l_output2+=("$result")
        fi
    done
    
    if [ ${#l_output2[@]} -ne 0 ]; then
        printf '%s\n' "- Audit Result:" " ** FAIL **"
        printf '%s\n' "- Reason(s) for audit failure:" "${l_output2[@]}"
    else
        printf '%s\n' "- Audit Result:" " ** PASS **" "${l_output[@]}"
    fi
}
```

## Remediation

1. Create the file `/etc/dconf/db/local.d/locks/00-media-autorun` with the following content:
```
# Lock autorun-never setting
/org/gnome/desktop/media-handling/autorun-never
```

2. Update the system databases:
```bash
dconf update
```

**Note:**
- A user profile must exist in order to apply locks.
- Users must log out and back in again before the system-wide settings take effect.

## References
1. NIST SP 800-53 Rev. 5: CM-1, CM-2, CM-6, CM-7, IA-5

## CIS Controls

| Controls Version | Control | IG 1 | IG 2 | IG 3 |
|------------------|---------|------|------|------|
| v8 | 10.3 Disable Autorun and Autoplay for Removable Media | ● | ● | ● |
| v7 | 8.5 Configure Devices Not To Auto-run Content | ● | ● | ● |

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1091, T1091.000 | TA0001, TA0008 | M1028 |
