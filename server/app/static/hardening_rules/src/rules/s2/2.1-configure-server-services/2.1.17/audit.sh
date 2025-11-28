#!/bin/bash
# 2.1.17 Ensure web proxy server services are not in use

# Check if squid is enabled
if systemctl is-enabled squid | grep -q 'enabled'; then
  echo "FAILED: squid is enabled"
  exit 1
fi

# Check if squid is active
if systemctl is-active squid | grep -q 'active'; then
  echo "FAILED: squid is active"
  exit 1
fi

echo "PASSED: web proxy server services are not in use"
exit 0
