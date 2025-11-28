#!/bin/bash
# 3.1.1 Ensure IPv6 status is identified

# Check if IPv6 is disabled in GRUB
if grep -P "^\s*linux" /boot/grub/grub.cfg 2>/dev/null | grep -q "ipv6.disable=1"; then
    echo "IPv6 is disabled in GRUB"
    exit 0
fi

# Check if IPv6 is disabled via sysctl
if sysctl net.ipv6.conf.all.disable_ipv6 2>/dev/null | grep -q "1" && \
   sysctl net.ipv6.conf.default.disable_ipv6 2>/dev/null | grep -q "1"; then
    echo "IPv6 is disabled via sysctl"
    exit 0
fi

echo "IPv6 status not identified as disabled. Please check manually."
exit 1
