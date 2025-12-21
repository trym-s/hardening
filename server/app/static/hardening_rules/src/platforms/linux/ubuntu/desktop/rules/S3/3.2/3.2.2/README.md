# 3.2.2 Ensure tipc kernel module is not available (Automated)

## Description
The Transparent Inter-Process Communication (TIPC) protocol is designed to provide communication between cluster nodes.

## Rationale
If the protocol is not required, it is recommended that the drivers not be installed to reduce the potential attack surface.

## Audit
Run the following commands to verify tipc is not available:
```bash
# Check if module is disabled
modprobe -n -v tipc 2>/dev/null | grep -E '(tipc|install)'

# Check if module is loaded
lsmod | grep tipc
```
Output should show `install /bin/true` or `install /bin/false` and no modules loaded.

## Remediation
Run the following commands to disable tipc:
```bash
# Create configuration to disable module
echo "install tipc /bin/true" >> /etc/modprobe.d/tipc.conf
echo "blacklist tipc" >> /etc/modprobe.d/tipc.conf

# Unload module if loaded
modprobe -r tipc 2>/dev/null
```
