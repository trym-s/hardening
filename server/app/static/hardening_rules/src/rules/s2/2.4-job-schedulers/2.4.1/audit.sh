#!/bin/bash
# 2.4.1 Ensure cron daemon is enabled

if systemctl is-enabled cron | grep -q 'enabled' && systemctl is-active cron | grep -q 'active'; then
  echo "PASSED: cron daemon is enabled and active"
  exit 0
else
  echo "FAILED: cron daemon is not enabled or active"
  exit 1
fi
