# 4.2.1 Ensure ufw is installed (Automated)

## Description
The Uncomplicated Firewall (ufw) is a frontend for iptables and is particularly well-suited for host-based firewalls.

## Rationale
A firewall utility is required to configure the Linux kernel's netfilter framework and provide protection against unwanted network access.

## Audit
```bash
dpkg -l | grep ufw
```
Output should show ufw is installed.

## Remediation
```bash
apt install ufw
```
