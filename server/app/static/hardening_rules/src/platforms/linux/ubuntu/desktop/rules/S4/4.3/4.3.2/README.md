# 4.3.2 Ensure ufw is uninstalled or disabled with nftables (Automated)

## Description
ufw should be disabled or removed when using nftables directly.

## Rationale
Running multiple firewall utilities can lead to conflicting rules.

## Audit
```bash
dpkg -l | grep ufw
ufw status
```

## Remediation
```bash
ufw disable
systemctl stop ufw
systemctl mask ufw
# Or remove: apt purge ufw
```
