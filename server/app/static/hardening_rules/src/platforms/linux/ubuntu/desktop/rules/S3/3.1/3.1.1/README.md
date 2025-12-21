# 3.1.1 Ensure IPv6 status is identified (Manual)

## Description
IPv6 is the most recent version of the Internet Protocol (IP). It is designed to address the long-anticipated problem of IPv4 address exhaustion.

## Rationale
IPv6 should be identified as needing to be enabled or not. If IPv6 is to be disabled, it should be disabled throughout the system to reduce the attack surface.

If IPv6 is not being used, it is recommended that it be disabled to reduce the attack surface of the system.

## Audit
Run the following command to determine if IPv6 is enabled:
```bash
# Check if IPv6 is disabled via GRUB
grep -Pq '^\s*GRUB_CMDLINE_LINUX="[^"]*ipv6\.disable=1' /etc/default/grub

# Check sysctl settings
sysctl net.ipv6.conf.all.disable_ipv6
sysctl net.ipv6.conf.default.disable_ipv6
```

If IPv6 is to be disabled, the output should show `ipv6.disable=1` or sysctl values of `1`.

## Remediation
If IPv6 is not required, disable it using one of the following methods:

**Method 1 - GRUB (recommended)**:
```bash
# Edit /etc/default/grub and add ipv6.disable=1 to GRUB_CMDLINE_LINUX
# Then run:
update-grub
```

**Method 2 - sysctl**:
```bash
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.d/60-disable_ipv6.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.d/60-disable_ipv6.conf
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
```

**Note**: This is a manual control. The decision to enable or disable IPv6 should be based on your organization's requirements.
