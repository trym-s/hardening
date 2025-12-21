# 5.2.2 Ensure sudo commands use pty (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
sudo can be configured to run only from a pseudo terminal (pseudo-pty).

## Rationale
Attackers can run a malicious program using sudo which would fork a background process that remains even when the main program has finished executing. This can be mitigated by configuring sudo to require a pty.

## Audit
```bash
grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,)?use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers*
```
Verify output includes `Defaults use_pty`.

## Remediation
```bash
echo "Defaults use_pty" >> /etc/sudoers.d/use_pty
```

## References
- NIST SP 800-53 Rev. 5: CM-6
