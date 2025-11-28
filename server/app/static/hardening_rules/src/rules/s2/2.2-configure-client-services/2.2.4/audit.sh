#!/bin/bash
# 2.2.4 Ensure rsh client is not installed

if dpkg -l | grep -q rsh-client; then
  echo "FAILED: rsh-client is installed"
  exit 1
fi

echo "PASSED: rsh client is not installed"
exit 0
