# 5.2.5 Ensure re-authentication for privilege escalation is not disabled globally (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The operating system must be configured so that the sudo command always requires re-authentication.

## Rationale
Without re-authentication, users may access resources or perform tasks for which they do not have authorization.

## Audit
```bash
grep -rPi -- '^\h*Defaults\h+([^#]+,\h*)?!authenticate' /etc/sudoers*
```
Verify no output is returned.

## Remediation
Remove any line containing `!authenticate` from `/etc/sudoers` and `/etc/sudoers.d/*` files.

## References
- NIST SP 800-53 Rev. 5: IA-11
