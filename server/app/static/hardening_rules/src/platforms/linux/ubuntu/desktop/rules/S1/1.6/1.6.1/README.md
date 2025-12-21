# 1.6.1 Ensure message of the day is configured properly (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The contents of the `/etc/motd` file are displayed to users after login and function as a message of the day for authenticated users.

Unix-based systems have typically displayed information about the OS release and patch level upon logging in to the system. This information can be useful to developers who are developing software for a particular OS platform. If `mingetty(8)` supports the following options, they display operating system information:
- `\m` - machine architecture
- `\r` - operating system release
- `\s` - operating system name
- `\v` - operating system version

## Rationale
Warning messages inform users who are attempting to login to the system of their legal status regarding the system and must include the name of the organization that owns the system and any monitoring policies that are in place. Displaying OS and patch level information in login banners also has the side effect of providing detailed system information to attackers attempting to target specific exploits of a system. Authorized users can easily get this information by running the `uname -a` command once they have logged in.

## Audit
1. Run the following command and verify that the contents match site policy:
```bash
cat /etc/motd
```

2. Run the following command and verify no results are returned:
```bash
grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/motd
```

## Remediation
Edit the `/etc/motd` file with the appropriate contents according to your site policy, remove any instances of `\m`, `\r`, `\s`, `\v` or references to the OS platform.

**OR**

If the motd is not used, this file can be removed:
```bash
rm /etc/motd
```

## References
1. NIST SP 800-53 Rev. 5: CM-6, CM-1, CM-3

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1082, T1082.000, T1592, T1592.004 | TA0007 | |
