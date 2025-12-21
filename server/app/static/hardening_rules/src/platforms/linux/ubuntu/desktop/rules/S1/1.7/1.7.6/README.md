# 1.7.6 Ensure GDM automatic mounting of removable media is disabled (Automated)

## Profile Applicability
- Level 1 - Server
- Level 2 - Workstation

## Description
By default GNOME automatically mounts removable media when inserted as a convenience to the user.

## Rationale
With automounting enabled anyone with physical access could attach a USB drive or disc and have its contents available in system even if they lacked permissions to mount it themselves.

## Impact
The use of portable hard drives is very common for workstation users. If your organization allows the use of portable storage or media on workstations and physical access controls to workstations is considered adequate there is little value add in turning off automounting.

## Audit
Run the following commands to verify automatic mounting is disabled:
```bash
gsettings get org.gnome.desktop.media-handling automount
```
Expected output: `false`

```bash
gsettings get org.gnome.desktop.media-handling automount-open
```
Expected output: `false`

## Remediation

### Option 1: If a user profile exists
Run the following commands to ensure automatic mounting is disabled:
```bash
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling automount-open false
```

**Note:**
- gsettings commands MUST be done from a command window on a graphical desktop
- The system must be restarted after all gsettings configurations have been set

### Option 2: If a user profile does not exist

1. Create a file `/etc/dconf/db/local.d/00-media-automount` with following content:
```
[org/gnome/desktop/media-handling]
automount=false
automount-open=false
```

2. Apply the changes:
```bash
dconf update
```

**Note:** Users must log out and back in again before the system-wide settings take effect.

## References
1. https://access.redhat.com/solutions/20107
2. NIST SP 800-53 Rev. 5: CM-1, CM-2, CM-6, CM-7, IA-5

## CIS Controls

| Controls Version | Control | IG 1 | IG 2 | IG 3 |
|------------------|---------|------|------|------|
| v8 | 10.3 Disable Autorun and Autoplay for Removable Media | ● | ● | ● |
| v7 | 8.5 Configure Devices Not To Auto-run Content | ● | ● | ● |

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1091, T1091.000 | TA0008 | M1042 |
