# 1.5.4 Ensure prelink is not installed (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
prelink is a program that modifies ELF shared libraries and ELF dynamically linked binaries in such a way that the time needed for the dynamic linker to perform relocations at startup significantly decreases.

## Rationale
The prelinking feature can interfere with the operation of AIDE, because it changes binaries. Prelinking can also increase the vulnerability of the system if a malicious user is able to compromise a common library such as libc.

## Audit
Verify prelink is not installed:
```bash
dpkg-query -s prelink &>/dev/null && echo "prelink is installed"
```
Nothing should be returned.

## Remediation
1. Run the following command to restore binaries to normal:
```bash
prelink -ua
```

2. Uninstall prelink using the appropriate package manager:
```bash
apt purge prelink
```

## References
1. NIST SP 800-53 Rev. 5: CM-6, CM-1, CM-3

## CIS Controls

| Controls Version | Control | IG 1 | IG 2 | IG 3 |
|------------------|---------|------|------|------|
| v8 | 3.14 Log Sensitive Data Access | | | ● |
| v7 | 14.9 Enforce Detail Logging for Access or Changes to Sensitive Data | | | ● |

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1055, T1055.009, T1065, T1065.001 | TA0002 | M1050 |
