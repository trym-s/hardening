# 5.1.15 Ensure sshd MACs are configured (Automated)

## Description
This variable limits the types of MAC (Message Authentication Code) algorithms that SSH can use during communication.

## Rationale
MD5 and 96-bit MAC algorithms are considered weak and should be disabled.

## Audit
```bash
sshd -T | grep -i macs
```
Verify only approved strong MACs are listed.

## Remediation
```bash
echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256" >> /etc/ssh/sshd_config
systemctl reload sshd
```
