# 5.1.10 Ensure sshd IgnoreRhosts is enabled (Automated)

## Description
The `IgnoreRhosts` parameter specifies that `.rhosts` and `.shosts` files will not be used in `RhostsRSAAuthentication` or `HostbasedAuthentication`.

## Rationale
Setting this parameter forces users to enter a password when authenticating with SSH.

## Audit
```bash
sshd -T | grep -i ignorerhosts
```
Should return `ignorerhosts yes`.

## Remediation
```bash
echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config
systemctl reload sshd
```
