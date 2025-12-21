# 2.1.1 Ensure autofs services are not in use (Automated)

## Profile Applicability
- Level 1 - Server
- Level 2 - Workstation

## Description
autofs allows automatic mounting of devices, typically including CD/DVDs and USB drives.

## Rationale
With automounting enabled anyone with physical access could attach a USB drive or disc and have its contents available in system even if they lacked permissions to mount it themselves.

## Audit
Run the following command to verify autofs is not installed:
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' autofs
```

Run the following command to verify autofs.service is not enabled:
```bash
systemctl is-enabled autofs.service 2>/dev/null | grep 'enabled'
```
Nothing should be returned.

## Remediation
Run the following command to stop, mask and remove autofs:
```bash
systemctl stop autofs.service
systemctl mask autofs.service
apt purge autofs
```

## References
1. NIST SP 800-53 Rev. 5: CM-7

## CIS Controls
| Version | Control | IG 1 | IG 2 | IG 3 |
|---------|---------|------|------|------|
| v8 | 4.8 Uninstall or Disable Unnecessary Services | | ● | ● |
