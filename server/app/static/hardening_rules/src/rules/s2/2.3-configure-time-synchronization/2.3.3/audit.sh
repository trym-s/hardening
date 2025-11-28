#!/bin/bash
# 2.3.3 Ensure chrony is configured

if [ ! -f /etc/chrony/chrony.conf ]; then
  echo "SKIPPED: chrony not installed"
  exit 0
fi

# Check if chrony runs as _chrony user
if grep -q "^user _chrony" /etc/chrony/chrony.conf; then
  echo "PASSED: chrony is configured"
  exit 0
else
  echo "FAILED: chrony is not correctly configured"
  exit 1
fi
