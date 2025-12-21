#!/bin/bash
# CIS 3.1.1 Ensure IPv6 status is identified (Manual)

echo "Checking IPv6 status..."
echo ""

IPV6_DISABLED=0

# Check if IPv6 is disabled in GRUB
if grep -Pqs '^\s*GRUB_CMDLINE_LINUX="[^"]*ipv6\.disable=1' /etc/default/grub; then
    echo "INFO: IPv6 is disabled via GRUB configuration"
    IPV6_DISABLED=1
fi

# Check if IPv6 is disabled via sysctl
ALL_DISABLE=$(sysctl -n net.ipv6.conf.all.disable_ipv6 2>/dev/null)
DEFAULT_DISABLE=$(sysctl -n net.ipv6.conf.default.disable_ipv6 2>/dev/null)

if [ "$ALL_DISABLE" = "1" ] && [ "$DEFAULT_DISABLE" = "1" ]; then
    echo "INFO: IPv6 is disabled via sysctl"
    IPV6_DISABLED=1
fi

# Check if IPv6 addresses exist on any interface
if ip -6 addr 2>/dev/null | grep -q "inet6"; then
    echo "INFO: IPv6 addresses are configured on interfaces"
    IPV6_ENABLED=1
else
    echo "INFO: No IPv6 addresses configured on interfaces"
    IPV6_ENABLED=0
fi

echo ""
echo "IPv6 Status Summary:"
echo "  GRUB ipv6.disable=1: $(grep -Pqs 'ipv6\.disable=1' /etc/default/grub && echo 'Yes' || echo 'No')"
echo "  sysctl all.disable_ipv6: ${ALL_DISABLE:-not set}"
echo "  sysctl default.disable_ipv6: ${DEFAULT_DISABLE:-not set}"
echo "  IPv6 addresses active: $([ "$IPV6_ENABLED" = "1" ] && echo 'Yes' || echo 'No')"
echo ""

# This is a manual check - always pass but report status
echo "AUDIT RESULT: MANUAL - Review IPv6 configuration based on site policy"
exit 0
