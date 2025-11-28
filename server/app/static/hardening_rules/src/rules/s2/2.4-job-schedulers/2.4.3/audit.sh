#!/bin/bash
# 2.4.3 Ensure permissions on /etc/cron.hourly are configured

if [ $(stat -c "%a %u %g" /etc/cron.hourly) == "700 0 0" ]; then
  echo "PASSED: /etc/cron.hourly permissions are correct"
  exit 0
else
  echo "FAILED: /etc/cron.hourly permissions are incorrect"
  exit 1
fi
