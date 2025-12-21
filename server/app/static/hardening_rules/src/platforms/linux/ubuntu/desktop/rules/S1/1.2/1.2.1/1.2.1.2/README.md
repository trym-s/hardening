# 1.2.1.2 Ensure package manager repositories are configured (Manual)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
Systems need to have package manager repositories configured to ensure they receive the latest patches and updates.

## Rationale
If a system's package repositories are misconfigured important patches may not be identified or a rogue repository could introduce compromised software.

## Audit
Run the following command and verify package repositories are configured correctly:

```bash
apt-cache policy
```

Or use the audit script:
```bash
./audit.sh
```

The audit script will display:
- Complete repository configuration via `apt-cache policy`
- Contents of `/etc/apt/sources.list`
- All repository files in `/etc/apt/sources.list.d/`

### What to Verify
✅ All repositories are official and trusted sources  
✅ Repositories align with organizational security policy  
✅ Security update repositories are enabled  
✅ No unauthorized or rogue repositories are present  

## Remediation
Configure your package manager repositories according to site policy.

### Configuration Files
- **Main sources file**: `/etc/apt/sources.list`
- **Additional repositories**: `/etc/apt/sources.list.d/*.list`

### Example: Ubuntu Security Updates
```bash
deb http://security.ubuntu.com/ubuntu jammy-security main restricted
deb http://security.ubuntu.com/ubuntu jammy-security universe multiverse
```

### Example: Debian Security Updates
```bash
deb http://security.debian.org/debian-security bullseye-security main
deb http://security.debian.org/debian-security bullseye-security contrib non-free
```

### Managing Repositories

#### Edit main sources file
```bash
sudo nano /etc/apt/sources.list
```

#### Add a repository
```bash
sudo add-apt-repository 'deb [options] http://repository.url distribution component'
```

#### Remove a repository
```bash
sudo add-apt-repository --remove 'deb [options] http://repository.url distribution component'
```

#### Update package lists after changes
```bash
sudo apt update
```

### Repository Line Format
```
deb [options] uri distribution [component1] [component2] [...]
```

- **deb**: Binary packages
- **deb-src**: Source packages
- **[options]**: Optional parameters like `[arch=amd64 signed-by=/path/to/key.gpg]`
- **uri**: Repository URL
- **distribution**: Release codename (e.g., jammy, bullseye)
- **component**: Repository sections (e.g., main, contrib, non-free, universe)

## References
1. NIST SP 800-53 Rev. 5: SI-2
2. [Debian Repository Format](https://debian.org/doc/manuals/debian-reference/ch02.en.html)
3. `man sources.list(5)`
4. `man apt-cache(8)`

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
- **Techniques/Subtechniques**: T1195, T1195.001, T1195.002 (Supply Chain Compromise)
- **Tactics**: TA0001 (Initial Access)
- **Mitigations**: M1051 (Update Software)

## Best Practices

> [!IMPORTANT]
> This is a **MANUAL** assessment requiring human verification against organizational policy.

### Security Recommendations
1. **Use official repositories only**: Prefer official Ubuntu/Debian repositories
2. **Enable security updates**: Ensure `-security` repositories are active
3. **Use HTTPS when possible**: Protects against man-in-the-middle attacks
4. **Verify GPG keys**: All repositories should have valid GPG signatures (see rule 1.2.1.1)
5. **Regular reviews**: Periodically audit repository configuration
6. **Document approved sources**: Maintain a list of organization-approved repositories

### Common Repository Issues
- ❌ Outdated or deprecated repository URLs
- ❌ Third-party PPAs without security vetting
- ❌ Security repositories disabled
- ❌ Unsigned or improperly signed repositories
- ❌ Repositories pointing to unmaintained mirrors

### Verification Checklist
- [ ] Security updates repository is enabled
- [ ] All repositories use trusted sources
- [ ] Repository URLs are correct and accessible
- [ ] GPG keys are properly configured for all repositories
- [ ] No unauthorized third-party repositories
- [ ] Configuration matches organizational policy
