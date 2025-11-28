#!/bin/bash
# 2.4.4 Ensure permissions on /etc/cron.daily are configured

if [ $(stat -c "%a %u %g" /etc/cron.daily) == "700 0 0" ]; then
  echo "PASSED: /etc/cron.daily permissions are correct"
  exit 0
else
  echo "FAILED: /etc/cron.daily permissions are incorrect"
  exit 1
fi
