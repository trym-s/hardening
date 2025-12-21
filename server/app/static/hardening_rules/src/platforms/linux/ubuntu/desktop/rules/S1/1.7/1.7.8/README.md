# 1.7.8 Ensure GDM autorun-never is enabled (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The autorun-never setting allows the GNOME Desktop Display Manager to disable autorun through GDM.

## Rationale
Malware on removable media may take advantage of Autorun features when the media is inserted into a system and execute.

## Audit
Run the following command to verify that autorun-never is set to true for GDM:
```bash
gsettings get org.gnome.desktop.media-handling autorun-never
```
Expected output: `true`

## Remediation

### Option 1: If a user profile exists
Run the following command to set autorun-never to true for GDM users:
```bash
gsettings set org.gnome.desktop.media-handling autorun-never true
```

**Note:**
- gsettings commands MUST be done from a command window on a graphical desktop
- The system must be restarted after all gsettings configurations have been set

### Option 2: If a user profile does not exist

1. Create the file `/etc/dconf/db/local.d/00-media-autorun` with the following content:
```
[org/gnome/desktop/media-handling]
autorun-never=true
```

2. Update the system databases:
```bash
dconf update
```

**Note:** Users must log out and back in again before the system-wide settings take effect.

## Default Value
`false`

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
| T1091, T1091.000 | TA0001, TA0008 | M1042 |
