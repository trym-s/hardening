#!/bin/bash
# 2.2.5 Ensure talk client is not installed

if dpkg -l | grep -q talk; then
  echo "FAILED: talk client is installed"
  exit 1
fi

echo "PASSED: talk client is not installed"
exit 0
