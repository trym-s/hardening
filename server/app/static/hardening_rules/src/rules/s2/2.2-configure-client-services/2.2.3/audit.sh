#!/bin/bash
# 2.2.3 Ensure nis client is not installed

if dpkg -l | grep -q nis; then
  echo "FAILED: nis client is installed"
  exit 1
fi

echo "PASSED: nis client is not installed"
exit 0
