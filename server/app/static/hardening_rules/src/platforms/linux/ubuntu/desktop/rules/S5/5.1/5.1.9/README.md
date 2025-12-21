# 5.1.9 Ensure sshd HostbasedAuthentication is disabled (Automated)

## Description
The `HostbasedAuthentication` parameter specifies if authentication is allowed through trusted hosts via the user's SSH key.

## Rationale
Even though the `.rhosts` files are ineffective if support is disabled in `/etc/pam.d/sshd`, disabling the ability to use `.rhosts` files in SSH provides an additional layer of protection.

## Audit
```bash
sshd -T | grep -i hostbasedauthentication
```
Should return `hostbasedauthentication no`.

## Remediation
```bash
echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config
systemctl reload sshd
```
