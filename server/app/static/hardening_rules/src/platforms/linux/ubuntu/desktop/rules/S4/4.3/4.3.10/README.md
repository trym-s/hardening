# 4.3.10 Ensure nftables rules are permanent (Automated)

## Description
Rules should be saved to persist across reboots.

## Rationale
Without saving, rules are lost on reboot.

## Audit
```bash
cat /etc/nftables.conf
```

## Remediation
```bash
nft list ruleset > /etc/nftables.conf
```
