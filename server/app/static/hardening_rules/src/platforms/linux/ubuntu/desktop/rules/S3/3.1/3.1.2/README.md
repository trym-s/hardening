# 3.1.2 Ensure wireless interfaces are disabled (Automated)

## Description
Wireless networking is used when wired networks are unavailable or for convenience.

## Rationale
If wireless is not to be used, wireless devices can be disabled to reduce the potential attack surface.

## Audit
Run the following command to verify wireless interfaces are disabled:
```bash
# Check if any wireless interfaces exist
find /sys/class/net/*/ -type d -name wireless 2>/dev/null

# Check if rfkill is available and wireless is blocked
rfkill list wifi 2>/dev/null
```
No output from the find command indicates no wireless interfaces. If rfkill shows wireless is blocked, that is also acceptable.

## Remediation
Run the following commands to disable wireless interfaces:
```bash
# Use rfkill to block all wireless
rfkill block wifi

# Or disable the wireless module if known
# Example: modprobe -r iwlwifi
```
