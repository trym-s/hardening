# 4.2.6 Ensure ufw firewall rules exist for all open ports (Manual)

## Description
All open ports should have explicit firewall rules to control access.

## Rationale
Without proper firewall rules, services may be accessible from unauthorized sources.

## Audit
```bash
# List listening ports
ss -tuln

# Compare with ufw rules
ufw status verbose
```
All listening ports should have corresponding ufw rules.

## Remediation
Add rules for required services:
```bash
# Example for SSH
ufw allow 22/tcp

# Example for HTTP/HTTPS
ufw allow 80/tcp
ufw allow 443/tcp
```
