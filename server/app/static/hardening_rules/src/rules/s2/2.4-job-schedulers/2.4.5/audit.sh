#!/bin/bash
# 2.4.5 Ensure permissions on /etc/cron.weekly are configured

if [ $(stat -c "%a %u %g" /etc/cron.weekly) == "700 0 0" ]; then
  echo "PASSED: /etc/cron.weekly permissions are correct"
  exit 0
else
  echo "FAILED: /etc/cron.weekly permissions are incorrect"
  exit 1
fi
