# 2.1.22 Ensure mail transfer agent is configured for local-only mode (Automated)

## Description
Mail Transfer Agents (MTA) process and route mail. The default MTA in Ubuntu is postfix.

## Rationale
The MTA should be configured to only process local mail to reduce the attack surface.

## Audit
```bash
ss -plntu | grep -E ':25\s' | grep -E -v '\s(127\.0\.0\.1|::1):25\s'
```
Nothing should be returned (only localhost should be listening).

## Remediation
Edit /etc/postfix/main.cf and add:
```
inet_interfaces = loopback-only
```

Then restart postfix:
```bash
systemctl restart postfix
```
