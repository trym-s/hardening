# 1.2.1.1 Ensure GPG keys are configured (Manual)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
Most package managers implement GPG key signing to verify package integrity during installation.

## Rationale
It is important to ensure that updates are obtained from a valid source to protect against spoofing that could lead to the inadvertent installation of malware on the system.

## Audit
Verify GPG keys are configured correctly for your package manager.

### Option 1: Using deprecated apt-key (not recommended)
```bash
apt-key list
```

> [!WARNING]
> `apt-key list` is deprecated. Manage keyring files in `trusted.gpg.d` instead (see `apt-key(8)`).

### Option 2: Recommended approach
Run the audit script to check GPG keys in modern locations:
```bash
./audit.sh
```

The script will check:
- `/etc/apt/trusted.gpg.d/*.{gpg,asc}`
- `/etc/apt/sources.list.d/*.{gpg,asc}`

**REVIEW and VERIFY** to ensure that GPG keys are configured correctly for your package manager in accordance with site policy.

## Remediation
Update your package manager GPG keys in accordance with site policy.

### Recommended Approach (Signed-By in sources.list)
With the deprecation of `apt-key`, it is recommended to use the **Signed-By** option in `sources.list` to require a repository to pass `apt-secure(8)` verification with a certain set of keys rather than all trusted keys apt has configured.

1. Place GPG keys in `/etc/apt/trusted.gpg.d/` as `.gpg` or `.asc` files
2. Reference them in source files using the `signed-by` option:
   ```
   deb [signed-by=/etc/apt/trusted.gpg.d/example.gpg] https://example.com/debian stable main
   ```

### Legacy Approach (apt-key - deprecated)
```bash
# Download and add key
wget -qO - https://example.com/key.gpg | apt-key add -

# Or add from file
apt-key add /path/to/key.gpg
```

## References
1. NIST SP 800-53 Rev. 5: SI-2
2. [sources.list manual](https://manpages.debian.org/stretch/apt/sources.list.5.en.html)
3. `man apt-key(8)`
4. `man apt-secure(8)`

## CIS Controls

### Version 8
| Control | Title | IG1 | IG2 | IG3 |
|---------|-------|-----|-----|-----|
| 7.3 | Perform Automated Operating System Patch Management | ● | ● | ● |
| 7.4 | Perform Automated Application Patch Management | ● | ● | ● |

### Version 7
| Control | Title | IG1 | IG2 | IG3 |
|---------|-------|-----|-----|-----|
| 3.4 | Deploy Automated Operating System Patch Management Tools | ● | ● | ● |
| 3.5 | Deploy Automated Software Patch Management Tools | ● | ● | ● |

## MITRE ATT&CK Mappings
- **Techniques/Subtechniques**: T1195, T1195.001, T1195.002
- **Tactics**: TA0001 (Initial Access)
- **Mitigations**: M1051 (Update Software)

## Notes
> [!IMPORTANT]
> This is a **MANUAL** assessment. Automated scripts can list the keys, but human review is required to verify they align with organizational security policy.

- Modern Debian/Ubuntu systems should use the `Signed-By` option in sources.list instead of the deprecated `apt-key` command
- GPG keys should be managed in `/etc/apt/trusted.gpg.d/` directory
- Each repository should ideally have its own GPG key file
- Regularly review and update GPG keys as part of security maintenance
