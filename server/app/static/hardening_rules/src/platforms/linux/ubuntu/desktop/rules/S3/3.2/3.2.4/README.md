# 3.2.4 Ensure sctp kernel module is not available (Automated)

## Description
The Stream Control Transmission Protocol (SCTP) is a transport layer protocol used to support message oriented communication, with several streams of messages in one connection.

## Rationale
If the protocol is not required, it is recommended that the drivers not be installed to reduce the potential attack surface.

## Audit
Run the following commands to verify sctp is not available:
```bash
# Check if module is disabled
modprobe -n -v sctp 2>/dev/null | grep -E '(sctp|install)'

# Check if module is loaded
lsmod | grep sctp
```
Output should show `install /bin/true` or `install /bin/false` and no modules loaded.

## Remediation
Run the following commands to disable sctp:
```bash
# Create configuration to disable module
echo "install sctp /bin/true" >> /etc/modprobe.d/sctp.conf
echo "blacklist sctp" >> /etc/modprobe.d/sctp.conf

# Unload module if loaded
modprobe -r sctp 2>/dev/null
```
