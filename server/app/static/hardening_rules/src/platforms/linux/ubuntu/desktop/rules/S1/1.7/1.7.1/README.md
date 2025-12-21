# 1.7.1 Ensure GDM is removed (Automated)

## Profile Applicability
- Level 2 - Server

## Description
The GNOME Display Manager (GDM) is a program that manages graphical display servers and handles graphical user logins.

## Rationale
If a Graphical User Interface (GUI) is not required, it should be removed to reduce the attack surface of the system.

## Impact
Removing the GNOME Display manager will remove the Graphical User Interface (GUI) from the system.

## Audit
Run the following command and verify gdm3 is not installed:
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' gdm3
```

Expected output:
```
gdm3 unknown ok not-installed not-installed
```

## Remediation
Run the following commands to uninstall gdm3 and remove unused dependencies:
```bash
apt purge gdm3
apt autoremove gdm3
```

## References
1. NIST SP 800-53 Rev. 5: CM-11

## CIS Controls

| Controls Version | Control | IG 1 | IG 2 | IG 3 |
|------------------|---------|------|------|------|
| v8 | 4.8 Uninstall or Disable Unnecessary Services on Enterprise Assets and Software | | ● | ● |
| v7 | 9.2 Ensure Only Approved Ports, Protocols and Services Are Running | | ● | ● |

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1543, T1543.002 | TA0002 | M1033 |
