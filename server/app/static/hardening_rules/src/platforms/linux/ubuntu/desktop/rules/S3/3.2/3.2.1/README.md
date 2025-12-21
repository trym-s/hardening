# 3.2.1 Ensure dccp kernel module is not available (Automated)

## Description
The Datagram Congestion Control Protocol (DCCP) is a transport layer protocol that supports streaming media and telephony.

## Rationale
If the protocol is not required, it is recommended that the drivers not be installed to reduce the potential attack surface.

## Audit
Run the following commands to verify dccp is not available:
```bash
# Check if module is disabled
modprobe -n -v dccp 2>/dev/null | grep -E '(dccp|install)'

# Check if module is loaded
lsmod | grep dccp
```
Output should show `install /bin/true` or `install /bin/false` and no modules loaded.

## Remediation
Run the following commands to disable dccp:
```bash
# Create configuration to disable module
echo "install dccp /bin/true" >> /etc/modprobe.d/dccp.conf
echo "blacklist dccp" >> /etc/modprobe.d/dccp.conf

# Unload module if loaded
modprobe -r dccp 2>/dev/null
```
