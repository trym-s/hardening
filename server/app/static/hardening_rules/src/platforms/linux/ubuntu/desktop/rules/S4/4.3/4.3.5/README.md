# 4.3.5 Ensure nftables base chains exist (Automated)

## Description
Chains are containers for rules. Base chains are entry points for packets.

## Rationale
Base chains are required for input, forward, and output packet processing.

## Audit
```bash
nft list ruleset | grep 'hook input'
nft list ruleset | grep 'hook forward'
nft list ruleset | grep 'hook output'
```

## Remediation
```bash
nft create chain inet filter input '{ type filter hook input priority 0; }'
nft create chain inet filter forward '{ type filter hook forward priority 0; }'
nft create chain inet filter output '{ type filter hook output priority 0; }'
```
