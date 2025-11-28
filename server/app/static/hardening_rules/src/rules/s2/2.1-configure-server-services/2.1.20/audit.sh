#!/bin/bash
# 2.1.20 Ensure X window server services are not in use

if dpkg -l | grep -q xserver-xorg; then
  echo "FAILED: X window server packages found"
  exit 1
fi

echo "PASSED: X window server services are not in use"
exit 0
