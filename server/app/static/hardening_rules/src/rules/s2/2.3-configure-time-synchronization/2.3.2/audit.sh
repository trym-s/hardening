#!/bin/bash
# 2.3.2 Ensure ntp is configured

if [ ! -f /etc/ntp.conf ]; then
  echo "SKIPPED: ntp not installed"
  exit 0
fi

# Check for restrict lines
if grep -q "^restrict default" /etc/ntp.conf && grep -q "^restrict -6 default" /etc/ntp.conf; then
  echo "PASSED: ntp is configured"
  exit 0
else
  echo "FAILED: ntp is not correctly configured"
  exit 1
fi
