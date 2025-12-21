# 2.1.2 Ensure avahi daemon services are not in use (Automated)

## Profile Applicability
- Level 1 - Server
- Level 2 - Workstation

## Description
Avahi is a free zeroconf implementation, including a system for multicast DNS/DNS-SD service discovery.

## Rationale
Automatic discovery of network services is not normally required for system functionality. It is recommended to disable the service to reduce the potential attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' avahi-daemon
systemctl is-enabled avahi-daemon.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop avahi-daemon.service
systemctl mask avahi-daemon.service
apt purge avahi-daemon
```
