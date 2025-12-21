# 4.1.1 Ensure a single firewall configuration utility is in use (Automated)

## Description
Firewalls are used to control network traffic and provide network-based security for various system services.

## Rationale
Using multiple firewalls at the same time can lead to confusion and unexpected results. Only one firewall should be configured and active.

Ubuntu supports three firewall utilities:
- **ufw** (Uncomplicated Firewall) - user-friendly frontend
- **nftables** - modern packet filtering framework (default in Ubuntu 24.04)
- **iptables** - legacy packet filtering

## Audit
Run the following command to verify only one firewall is active:
```bash
# Check which firewall utilities are enabled
systemctl is-enabled ufw.service 2>/dev/null
systemctl is-enabled nftables.service 2>/dev/null
```
Only ONE should be enabled/active.

## Remediation
Choose ONE firewall utility and disable the others:

**If using UFW:**
```bash
apt install ufw
systemctl unmask ufw.service
systemctl enable ufw.service
systemctl start ufw.service
ufw enable
# Disable nftables
systemctl stop nftables.service
systemctl disable nftables.service
```

**If using nftables:**
```bash
apt install nftables
systemctl unmask nftables.service
systemctl enable nftables.service
systemctl start nftables.service
# Disable UFW
ufw disable
systemctl stop ufw.service
systemctl disable ufw.service
```
