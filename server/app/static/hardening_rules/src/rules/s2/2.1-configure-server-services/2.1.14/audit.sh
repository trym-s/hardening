#!/bin/bash
# 2.1.14 Ensure samba file server services are not in use

# Check if smbd is enabled
if systemctl is-enabled smbd | grep -q 'enabled'; then
  echo "FAILED: smbd is enabled"
  exit 1
fi

# Check if smbd is active
if systemctl is-active smbd | grep -q 'active'; then
  echo "FAILED: smbd is active"
  exit 1
fi

echo "PASSED: samba file server services are not in use"
exit 0
