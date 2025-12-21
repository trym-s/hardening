# 4.2.5 Ensure ufw outbound connections are configured (Manual)

## Description
Configure the firewall rules for outbound connections.

## Rationale
If rules are not in place for new outbound connections, all connections could be blocked.

## Audit
```bash
ufw status verbose
```
Verify that outbound connections are configured as appropriate for your organization's policy.

## Remediation
Configure outbound rules based on your requirements:
```bash
# Allow all outbound (common configuration)
ufw default allow outgoing

# Or allow specific ports
ufw allow out 53
ufw allow out 80
ufw allow out 443
```
