#!/bin/bash
# 2.2.6 Ensure telnet client is not installed

if dpkg -l | grep -q telnet; then
  echo "FAILED: telnet client is installed"
  exit 1
fi

echo "PASSED: telnet client is not installed"
exit 0
