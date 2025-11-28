#!/bin/bash
# 2.4.7 Ensure permissions on /etc/cron.d are configured

if [ "$(stat -c "%a %u %g" /etc/cron.d)" == "700 0 0" ]; then
  echo "PASSED: /etc/cron.d permissions are correct"
  exit 0
else
  echo "FAILED: /etc/cron.d permissions are incorrect"
  exit 1
fi
