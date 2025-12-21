# 1.2.2.1 Ensure updates, patches, and additional security software are installed (Manual)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
Periodically patches are released for included software either due to security flaws or to include additional functionality.

## Rationale
Newer patches may contain security enhancements that would not be available through the latest full update. As a result, it is recommended that the latest software patches be used to take advantage of the latest functionality. As with any software installation, organizations need to determine if a given update meets their requirements and verify the compatibility and supportability of any additional software against the update revision that is selected.

## Audit
Verify there are no updates or patches to install:

```bash
apt update
apt -s upgrade
```

Or use the audit script:
```bash
./audit.sh
```

The audit script will:
- Update package lists
- Run a simulation of available upgrades
- Report the number of packages that can be upgraded
- Exit with status 0 if no updates available, 1 if updates are available

## Remediation
Run the following command to update all packages following local site policy guidance on applying updates and patches.

### Method 1: Standard Upgrade (Recommended)
```bash
apt update
apt upgrade
```

**Behavior**: Installs the newest versions of all packages currently installed on the system. Under no circumstances are currently installed packages removed, or packages not already installed retrieved and installed.

### Method 2: Distribution Upgrade
```bash
apt update
apt dist-upgrade
```

**Behavior**: In addition to performing the function of upgrade, also intelligently handles changing dependencies with new versions of packages. The `dist-upgrade` command may remove some packages if necessary to resolve conflicts.

### Security-Only Updates (Example)
```bash
# Review security updates
apt list --upgradable | grep -i security

# Install security updates only
apt install --only-upgrade $(apt list --upgradable 2>/dev/null | grep security | cut -d'/' -f1)
```

## Differences Between Commands

| Feature | `apt upgrade` | `apt dist-upgrade` |
|---------|---------------|-------------------|
| Install new packages | No | Yes, if needed for dependencies |
| Remove packages | No | Yes, if needed for conflicts |
| Change dependencies | Conservative | Intelligent handling |
| Use case | Regular updates | Major version upgrades |
| Risk level | Lower | Higher (may break things) |

## Additional Information

> [!IMPORTANT]
> Site policy may mandate a testing period before installation onto production systems for available updates.

### Understanding apt upgrade
- Used to install the newest versions of all packages currently installed on the system
- Sources enumerated in `/etc/apt/sources.list` or `/etc/apt/sources.list.d/`
- Packages currently installed with new versions available are retrieved and upgraded
- **Never removes** currently installed packages
- **Never installs** packages not already installed
- Packages that cannot be upgraded without changing install status are left at current version
- An `apt update` must be performed first

### Understanding apt dist-upgrade
- Performs all functions of `apt upgrade`
- **Intelligently handles** changing dependencies with new versions
- Has a "smart" conflict resolution system
- May **remove some packages** if necessary
- Attempts to upgrade most important packages at the expense of less important ones
- See `apt_preferences(5)` for overriding general settings for individual packages

## Best Practices

### Pre-Update Checklist
- [ ] Review organizational change management policy
- [ ] Check for scheduled maintenance windows
- [ ] Create system backup or snapshot
- [ ] Review the list of updates to be installed
- [ ] Test updates in non-production environment (if required)
- [ ] Verify sufficient disk space for updates
- [ ] Ensure system has network connectivity

### Post-Update Actions
- [ ] Review update logs for errors
- [ ] Verify critical services are running
- [ ] Check for required system reboot
  ```bash
  # Check if reboot is required
  [ -f /var/run/reboot-required ] && cat /var/run/reboot-required
  ```
- [ ] Document updates applied
- [ ] Monitor system for issues

### Automated Updates Consideration
For fully automated updates (not manual), consider using:
```bash
# Install unattended-upgrades
apt install unattended-upgrades

# Configure automatic security updates
dpkg-reconfigure --priority=low unattended-upgrades
```

> [!WARNING]
> Automatic updates should be carefully evaluated against organizational requirements and may not be appropriate for all systems (especially production servers).

## Common Issues and Solutions

### Issue: Held Packages
```bash
# List held packages
apt-mark showhold

# Unhold a package
apt-mark unhold package-name
```

### Issue: Broken Dependencies
```bash
# Fix broken dependencies
apt --fix-broken install
```

### Issue: Package Manager Locked
```bash
# Check for running apt processes
ps aux | grep -i apt

# Remove lock file (only if no apt processes are running)
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*
```

## References
1. NIST SP 800-53 Rev. 5: SI-2
2. `man apt(8)`
3. `man apt-get(8)`
4. `man apt_preferences(5)`

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
- **Techniques/Subtechniques**: T1195, T1195.001 (Supply Chain Compromise)
- **Tactics**: TA0005 (Defense Evasion)
- **Mitigations**: M1051 (Update Software)

## Security Considerations

> [!CAUTION]
> Always review updates before installation to ensure compatibility with your environment.

### Key Points
1. **Testing**: Test updates in non-production environments when possible
2. **Backups**: Always have recent backups before major updates
3. **Timing**: Apply updates during approved maintenance windows
4. **Monitoring**: Monitor systems after updates for unexpected behavior
5. **Documentation**: Document all updates applied for audit trails
6. **Rollback Plan**: Have a rollback strategy for critical systems

### Update Priority Levels
1. **Critical Security Updates**: Apply as soon as tested and approved
2. **Important Security Updates**: Apply within site policy timeframes
3. **Recommended Updates**: Schedule during regular maintenance
4. **Optional Updates**: Evaluate based on business need
