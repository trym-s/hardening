# 2.1.5 Ensure dnsmasq services are not in use (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
dnsmasq is a lightweight tool that provides DNS caching, DNS forwarding and DHCP services.

## Rationale
Unless specifically required, it is recommended to disable dnsmasq to reduce the attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' dnsmasq
systemctl is-enabled dnsmasq.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop dnsmasq.service
systemctl mask dnsmasq.service
apt purge dnsmasq
```
