# 5.1.7 Ensure sshd DisableForwarding is enabled (Automated)

## Description
The `DisableForwarding` option disables TCP forwarding, StreamLocal forwarding, and X11 forwarding.

## Rationale
SSH port forwarding should be disabled if not required to reduce the attack surface.

## Audit
```bash
sshd -T | grep -i disableforwarding
```
Should return `disableforwarding yes`.

## Remediation
```bash
echo "DisableForwarding yes" >> /etc/ssh/sshd_config
systemctl reload sshd
```
