# 5.1.5 Ensure sshd Banner is configured (Automated)

## Description
The `Banner` option in SSH configuration specifies a file to display before authentication.

## Rationale
Banners are used to warn connecting users of the particular site's policy regarding access.

## Audit
```bash
sshd -T | grep -i banner
```
Should return `banner /etc/issue.net` or another appropriate banner file.

## Remediation
```bash
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
systemctl reload sshd
```
