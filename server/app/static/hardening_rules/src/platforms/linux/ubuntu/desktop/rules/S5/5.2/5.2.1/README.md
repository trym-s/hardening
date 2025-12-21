# 5.2.1 Ensure sudo is installed (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
`sudo` allows a permitted user to execute a command as the superuser or another user, as specified by the security policy.

## Rationale
`sudo` supports a plugin architecture for security policies and input/output logging. Third parties can develop and distribute their own policy and I/O logging plugins to work seamlessly with the sudo front end.

## Audit
```bash
dpkg-query -W sudo
```
Verify sudo is installed.

## Remediation
```bash
apt install sudo
```

## References
- NIST SP 800-53 Rev. 5: AC-6
