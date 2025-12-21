# 2.1.3 Ensure dhcp server services are not in use (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The Dynamic Host Configuration Protocol (DHCP) is a service that allows machines to be dynamically assigned IP addresses.

## Rationale
Unless a system is specifically set up to act as a DHCP server, it is recommended that this service be disabled to reduce the potential attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' isc-dhcp-server
systemctl is-enabled isc-dhcp-server.service isc-dhcp-server6.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop isc-dhcp-server.service isc-dhcp-server6.service
systemctl mask isc-dhcp-server.service isc-dhcp-server6.service
apt purge isc-dhcp-server
```
