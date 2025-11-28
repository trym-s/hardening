#!/bin/bash
# 2.4.8 Ensure at is not installed

if dpkg -l | grep -q at; then
  echo "FAILED: at is installed"
  exit 1
fi

echo "PASSED: at is not installed"
exit 0
