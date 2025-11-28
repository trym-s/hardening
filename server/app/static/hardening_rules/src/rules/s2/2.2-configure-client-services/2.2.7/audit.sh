#!/bin/bash
# 2.2.7 Ensure tftp client is not installed

if dpkg -l | grep -q tftp; then
  echo "FAILED: tftp client is installed"
  exit 1
fi

echo "PASSED: tftp client is not installed"
exit 0
