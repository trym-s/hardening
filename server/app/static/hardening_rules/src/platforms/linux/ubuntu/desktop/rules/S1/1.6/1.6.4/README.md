# 1.6.4 Ensure access to /etc/motd is configured (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The contents of the `/etc/motd` file are displayed to users after login and function as a message of the day for authenticated users.

## Rationale
If the `/etc/motd` file does not have the correct access configured, it could be modified by unauthorized users with incorrect or misleading information.

## Audit
Run the following command and verify that if `/etc/motd` exists, Access is 644 or more restrictive, Uid and Gid are both 0/root:
```bash
[ -e /etc/motd ] && stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/motd
```

Expected output:
```
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
```
**OR** Nothing is returned (file doesn't exist)

## Remediation
Run the following commands to set mode, owner, and group on `/etc/motd`:
```bash
chown root:root $(readlink -e /etc/motd)
chmod u-x,go-wx $(readlink -e /etc/motd)
```

**OR**

Run the following command to remove the `/etc/motd` file:
```bash
rm /etc/motd
```

## References
1. NIST SP 800-53 Rev. 5: AC-3, MP-2

## CIS Controls

| Controls Version | Control | IG 1 | IG 2 | IG 3 |
|------------------|---------|------|------|------|
| v8 | 3.3 Configure Data Access Control Lists | ● | ● | ● |
| v7 | 14.6 Protect Information through Access Control Lists | ● | ● | ● |

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1222, T1222.002 | TA0005 | M1022 |
