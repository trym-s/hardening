# 4.3.8 Ensure nftables default deny firewall policy (Automated)

## Description
Default deny drops all traffic not explicitly permitted.

## Rationale
A default deny policy provides a secure baseline.

## Audit
```bash
nft list ruleset | grep 'policy drop'
```

## Remediation
```bash
nft chain inet filter input '{ policy drop; }'
nft chain inet filter forward '{ policy drop; }'
nft chain inet filter output '{ policy drop; }'
```
