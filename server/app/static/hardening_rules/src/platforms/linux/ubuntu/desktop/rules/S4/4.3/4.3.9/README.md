# 4.3.9 Ensure nftables service is enabled (Automated)

## Description
The nftables service loads rules at boot.

## Rationale
Enables persistent firewall configuration across reboots.

## Audit
```bash
systemctl is-enabled nftables
```

## Remediation
```bash
systemctl enable nftables
```
