# 4.3.1 Ensure nftables is installed (Automated)

## Description
nftables is the successor to iptables and provides packet filtering in the Linux kernel.

## Rationale
nftables is the default firewall framework in Ubuntu 24.04 and provides improved performance.

## Audit
```bash
dpkg -l | grep nftables
```

## Remediation
```bash
apt install nftables
```
