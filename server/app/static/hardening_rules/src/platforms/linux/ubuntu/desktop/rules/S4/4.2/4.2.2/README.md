# 4.2.2 Ensure iptables-persistent is not installed with ufw (Automated)

## Description
The iptables-persistent package is used to save iptables rules and restore them at boot.

## Rationale
Running both ufw and iptables-persistent can lead to conflicting firewall rules and potential security issues.

## Audit
```bash
dpkg -l | grep iptables-persistent
```
Should return no output if not installed.

## Remediation
```bash
apt purge iptables-persistent -y
```
