# 2.1.16 Ensure telnet server services are not in use (Automated)

## Description
Telnet provides a command line interface for communication with a remote device or server.

## Rationale
Telnet is insecure as it transmits all data in cleartext. Use SSH instead.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' telnetd
systemctl is-enabled telnet.socket 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop telnet.socket
systemctl mask telnet.socket
apt purge telnetd
```
