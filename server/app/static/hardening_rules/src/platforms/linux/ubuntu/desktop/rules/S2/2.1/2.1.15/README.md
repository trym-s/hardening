# 2.1.15 Ensure snmp services are not in use (Automated)

## Description
SNMP (Simple Network Management Protocol) is used for network device management.

## Rationale
Unless specifically required, disable SNMP to reduce attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' snmpd
systemctl is-enabled snmpd.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop snmpd.service
systemctl mask snmpd.service
apt purge snmpd
```
