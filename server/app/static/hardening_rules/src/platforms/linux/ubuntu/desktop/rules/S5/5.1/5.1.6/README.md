# 5.1.6 Ensure sshd Ciphers are configured (Automated)

## Description
This variable limits the ciphers that SSH can use during communication.

## Rationale
Weak ciphers should not be used. Only strong ciphers should be allowed.

## Audit
```bash
sshd -T | grep ciphers
```
Verify only approved strong ciphers are listed.

## Remediation
```bash
echo "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr" >> /etc/ssh/sshd_config
systemctl reload sshd
```
