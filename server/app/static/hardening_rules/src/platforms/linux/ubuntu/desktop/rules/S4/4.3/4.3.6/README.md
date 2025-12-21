# 4.3.6 Ensure nftables loopback traffic is configured (Automated)

## Description
Configure loopback traffic rules for nftables.

## Rationale
Loopback traffic is essential for many system services.

## Audit
```bash
nft list ruleset | grep 'iif "lo"'
```

## Remediation
```bash
nft add rule inet filter input iif lo accept
nft add rule inet filter input ip saddr 127.0.0.0/8 counter drop
```
