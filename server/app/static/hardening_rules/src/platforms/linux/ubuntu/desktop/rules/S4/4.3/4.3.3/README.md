# 4.3.3 Ensure iptables are flushed with nftables (Manual)

## Description
iptables rules should be flushed before implementing nftables rules.

## Rationale
Flushing iptables ensures no legacy rules conflict with nftables.

## Audit
```bash
iptables -L
ip6tables -L
```
Both should show empty chains.

## Remediation
```bash
iptables -F
ip6tables -F
```
