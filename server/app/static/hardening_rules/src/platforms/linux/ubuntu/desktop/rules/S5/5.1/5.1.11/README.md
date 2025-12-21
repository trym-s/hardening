# 5.1.11 Ensure sshd KerberosAuthentication is disabled (Automated)

## Description
Kerberos authentication for SSH should only be used if required.

## Rationale
Kerberos authentication should be disabled to reduce the attack surface unless specifically required.

## Audit
```bash
sshd -T | grep -i kerberosauthentication
```
Should return `kerberosauthentication no`.

## Remediation
```bash
echo "KerberosAuthentication no" >> /etc/ssh/sshd_config
systemctl reload sshd
```
