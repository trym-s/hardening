# 1.6.6 Ensure access to /etc/issue.net is configured (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The contents of the `/etc/issue.net` file are displayed to users prior to login for remote connections from configured services.

## Rationale
If the `/etc/issue.net` file does not have the correct access configured, it could be modified by unauthorized users with incorrect or misleading information.

## Audit
Run the following command and verify Access is 644 or more restrictive and Uid and Gid are both 0/root:
```bash
stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/issue.net
```

Expected output:
```
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
```

## Remediation
Run the following commands to set mode, owner, and group on `/etc/issue.net`:
```bash
chown root:root $(readlink -e /etc/issue.net)
chmod 644 $(readlink -e /etc/issue.net)
```

## Default Value
```
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
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
