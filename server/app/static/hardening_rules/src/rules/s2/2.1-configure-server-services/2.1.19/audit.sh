#!/bin/bash
# 2.1.19 Ensure xinetd services are not in use

# Check if xinetd is enabled
if systemctl is-enabled xinetd | grep -q 'enabled'; then
  echo "FAILED: xinetd is enabled"
  exit 1
fi

# Check if xinetd is active
if systemctl is-active xinetd | grep -q 'active'; then
  echo "FAILED: xinetd is active"
  exit 1
fi

echo "PASSED: xinetd services are not in use"
exit 0
