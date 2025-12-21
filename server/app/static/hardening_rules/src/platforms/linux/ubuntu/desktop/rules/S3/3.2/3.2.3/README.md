# 3.2.3 Ensure rds kernel module is not available (Automated)

## Description
The Reliable Datagram Sockets (RDS) protocol is a transport layer protocol designed to provide low-latency, high-bandwidth communications between cluster nodes.

## Rationale
If the protocol is not required, it is recommended that the drivers not be installed to reduce the potential attack surface.

## Audit
Run the following commands to verify rds is not available:
```bash
# Check if module is disabled
modprobe -n -v rds 2>/dev/null | grep -E '(rds|install)'

# Check if module is loaded
lsmod | grep rds
```
Output should show `install /bin/true` or `install /bin/false` and no modules loaded.

## Remediation
Run the following commands to disable rds:
```bash
# Create configuration to disable module
echo "install rds /bin/true" >> /etc/modprobe.d/rds.conf
echo "blacklist rds" >> /etc/modprobe.d/rds.conf

# Unload module if loaded
modprobe -r rds 2>/dev/null
```
