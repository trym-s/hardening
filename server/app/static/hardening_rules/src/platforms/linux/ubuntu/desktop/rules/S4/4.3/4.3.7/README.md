# 4.3.7 Ensure nftables outbound and established connections are configured (Manual)

## Description
Configure nftables to allow outbound and established connections.

## Rationale
Allows new outbound connections and related/established return traffic.

## Audit
```bash
nft list ruleset | grep 'ct state'
```

## Remediation
```bash
nft add rule inet filter input ip protocol tcp ct state established accept
nft add rule inet filter input ip protocol udp ct state established accept
nft add rule inet filter input ip protocol icmp ct state established accept
nft add rule inet filter output ip protocol tcp ct state new,related,established accept
nft add rule inet filter output ip protocol udp ct state new,related,established accept
nft add rule inet filter output ip protocol icmp ct state new,related,established accept
```
