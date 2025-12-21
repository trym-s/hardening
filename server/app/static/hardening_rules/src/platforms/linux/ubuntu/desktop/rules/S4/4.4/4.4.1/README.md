# 4.4.1 Configure iptables (IPv4)

## Description
This section covers iptables (IPv4) configuration if iptables is used instead of ufw or nftables.

## Rationale
iptables provides packet filtering for IPv4. Only use this section if NOT using ufw or nftables.

## Subsections
- 4.4.1.1 - Ensure iptables packages are installed
- 4.4.1.2 - Ensure iptables default deny firewall policy
- 4.4.1.3 - Ensure iptables loopback traffic is configured
- 4.4.1.4 - Ensure iptables outbound and established connections configured
- 4.4.1.5 - Ensure iptables firewall rules exist for all open ports
- 4.4.1.6 - Ensure iptables rules are saved
- 4.4.1.7 - Ensure iptables service is enabled

## Note
Ubuntu 24.04 defaults to nftables. This section is for legacy configurations.
