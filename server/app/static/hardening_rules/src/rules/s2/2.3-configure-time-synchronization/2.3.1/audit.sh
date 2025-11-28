#!/bin/bash
# 2.3.1 Ensure time synchronization is in use

if systemctl is-active systemd-timesyncd | grep -q 'active' || \
   systemctl is-active chrony | grep -q 'active' || \
   systemctl is-active ntp | grep -q 'active'; then
  echo "PASSED: Time synchronization is in use"
  exit 0
else
  echo "FAILED: No time synchronization service is active"
  exit 1
fi
