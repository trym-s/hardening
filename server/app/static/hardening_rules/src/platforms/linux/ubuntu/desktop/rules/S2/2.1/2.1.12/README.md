# 2.1.12 Ensure rpcbind services are not in use (Automated)

## Description
rpcbind is a server that converts RPC program numbers into universal addresses.

## Rationale
If rpcbind is not required, disable it to reduce attack surface.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' rpcbind
systemctl is-enabled rpcbind.service rpcbind.socket 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop rpcbind.service rpcbind.socket
systemctl mask rpcbind.service rpcbind.socket
apt purge rpcbind
```
