# 5.2.4 Ensure users must provide password for privilege escalation (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The operating system must be configured so that users must provide a password for privilege escalation.

## Rationale
Without re-authentication, users may access resources or perform tasks for which they do not have authorization.

## Audit
```bash
grep -rPi -- '^\h*([^#\n\r]+)?NOPASSWD' /etc/sudoers*
```
Verify no output is returned (NOPASSWD should not be configured).

## Remediation
Remove any line containing `NOPASSWD` from `/etc/sudoers` and `/etc/sudoers.d/*` files.

## References
- NIST SP 800-53 Rev. 5: IA-11
