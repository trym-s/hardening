#!/bin/bash
# 2.1.13 Ensure rsync services are not in use

# Check if rsync is enabled
if systemctl is-enabled rsync | grep -q 'enabled'; then
  echo "FAILED: rsync is enabled"
  exit 1
fi

# Check if rsync is active
if systemctl is-active rsync | grep -q 'active'; then
  echo "FAILED: rsync is active"
  exit 1
fi

echo "PASSED: rsync services are not in use"
exit 0
