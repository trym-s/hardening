#!/bin/bash
# 2.2.1 Ensure ftp client is not installed

if dpkg -l | grep -q ftp; then
  echo "FAILED: ftp client is installed"
  exit 1
fi

echo "PASSED: ftp client is not installed"
exit 0
