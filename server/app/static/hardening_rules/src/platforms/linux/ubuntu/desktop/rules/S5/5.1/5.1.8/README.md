# 5.1.8 Ensure sshd GSSAPIAuthentication is disabled (Automated)

## Description
GSSAPI authentication is used to provide additional authentication mechanisms to applications.

## Rationale
Unless needed, GSSAPI authentication should be disabled to reduce the attack surface.

## Audit
```bash
sshd -T | grep -i gssapiauthentication
```
Should return `gssapiauthentication no`.

## Remediation
```bash
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config
systemctl reload sshd
```
