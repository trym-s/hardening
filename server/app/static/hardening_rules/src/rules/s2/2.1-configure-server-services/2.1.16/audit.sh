#!/bin/bash
# 2.1.16 Ensure tftp server services are not in use

# Check if tftpd-hpa is enabled
if systemctl is-enabled tftpd-hpa | grep -q 'enabled'; then
  echo "FAILED: tftpd-hpa is enabled"
  exit 1
fi

# Check if tftpd-hpa is active
if systemctl is-active tftpd-hpa | grep -q 'active'; then
  echo "FAILED: tftpd-hpa is active"
  exit 1
fi

echo "PASSED: tftp server services are not in use"
exit 0
