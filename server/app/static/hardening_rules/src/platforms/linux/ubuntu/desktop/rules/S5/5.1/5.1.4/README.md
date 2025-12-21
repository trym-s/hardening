# 5.1.4 Ensure sshd access is configured (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
There are several options available to limit which users and group can access the system via SSH. It is recommended that at least one of the following options be leveraged:

- **AllowUsers**: Allows specific users to ssh into the system. The list consists of space separated user names. Entry can be specified in the form of `user@host`.
- **AllowGroups**: Allows specific groups of users to ssh into the system. The list consists of space separated group names.
- **DenyUsers**: Denies specific users to ssh into the system. The list consists of space separated user names. Entry can be specified in the form of `user@host`.
- **DenyGroups**: Denies specific groups of users to ssh into the system. The list consists of space separated group names.

## Rationale
Restricting which users can remotely access the system via SSH will help ensure that only authorized users access the system.

## Audit
```bash
sshd -T | grep -Pi -- '^\h*(allow|deny)(users|groups)\h+\H+'
```

Verify that the output matches at least one of the following lines:
- `allowusers <userlist>` -OR-
- `allowgroups <grouplist>` -OR-
- `denyusers <userlist>` -OR-
- `denygroups <grouplist>`

Review the list(s) to ensure included users and/or groups follow local site policy.

**Note:** If Match set statements are used, verify the setting is not incorrectly configured in a match block:
```bash
sshd -T -C user=sshuser | grep -Pi -- '^\h*(allow|deny)(users|groups)\h+\H+'
```

## Remediation
```bash
# Recommended: Use AllowGroups (easier to manage than allow/deny lists)
echo "AllowGroups sudo" >> /etc/ssh/sshd_config
systemctl reload sshd
```

**Alternative options:**
```bash
# Allow specific users
echo "AllowUsers user1 user2" >> /etc/ssh/sshd_config

# Deny specific users
echo "DenyUsers guest" >> /etc/ssh/sshd_config

# Deny specific groups
echo "DenyGroups nogroup" >> /etc/ssh/sshd_config

systemctl reload sshd
```

> [!IMPORTANT]
> - Options are "ANDed" together. If both AllowUsers and AllowGroups are set, connections are limited to users who are also members of an allowed group.
> - It is recommended to use only **ONE** option for clarity and ease of administration.
> - It is easier to manage an allow list than a deny list.

> [!CAUTION]
> Always test SSH connection in a new terminal before closing current session!

## Default Value
None

## References
- SSHD_CONFIG(5)
- NIST SP 800-53 Rev. 5: AC-3, MP-2
- CIS Controls v8: 3.3
- MITRE ATT&CK: T1021, T1021.004
