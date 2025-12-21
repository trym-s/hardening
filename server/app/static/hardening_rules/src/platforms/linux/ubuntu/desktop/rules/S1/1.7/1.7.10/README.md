# 1.7.10 Ensure XDMCP is not enabled (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
X Display Manager Control Protocol (XDMCP) is designed to provide authenticated access to display management services for remote displays.

## Rationale
XDMCP is inherently insecure:
- XDMCP is not a ciphered protocol. This may allow an attacker to capture keystrokes entered by a user.
- XDMCP is vulnerable to man-in-the-middle attacks. This may allow an attacker to steal the credentials of legitimate users by impersonating the XDMCP server.

## Audit
Run the following script and verify nothing is returned:
```bash
#!/usr/bin/env bash
{
    while IFS= read -r l_file; do
        awk '/\[xdmcp\]/{ f = 1;next } /\[/{ f = 0 } f {if (/^\s*Enable\s*=\s*true/) print "The file: \"'"$l_file"'\" includes: \"" $0 "\" in the \"[xdmcp]\" block"}' "$l_file"
    done < <(grep -Psil -- '^\h*\[xdmcp\]' /etc/{gdm3,gdm}/{custom,daemon}.conf 2>/dev/null)
}
```
Nothing should be returned.

## Remediation
Edit all files returned by the audit and remove or comment out the `Enable=true` line in the `[xdmcp]` block.

Example configuration:
```
[xdmcp]
# Enable=true <- This line should be removed or commented out
```

## Default Value
`false` (denoted by no `Enabled=` entry in the `[xdmcp]` block)

## References
1. NIST SP 800-53 Rev. 5: SI-4

## CIS Controls

| Controls Version | Control | IG 1 | IG 2 | IG 3 |
|------------------|---------|------|------|------|
| v8 | 4.8 Uninstall or Disable Unnecessary Services on Enterprise Assets and Software | | ● | ● |
| v7 | 9.2 Ensure Only Approved Ports, Protocols and Services Are Running | | ● | ● |

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1040, T1040.000, T1056, T1056.001, T1557, T1557.000 | TA0002 | M1050 |
