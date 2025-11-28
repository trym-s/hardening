#!/bin/bash
# 2.4.6 Ensure permissions on /etc/cron.monthly are configured

if [ "$(stat -c "%a %u %g" /etc/cron.monthly)" == "700 0 0" ]; then
  echo "PASSED: /etc/cron.monthly permissions are correct"
  exit 0
else
  echo "FAILED: /etc/cron.monthly permissions are incorrect"
  exit 1
fi
