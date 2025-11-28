#!/bin/bash
# 2.4.2 Ensure permissions on /etc/crontab are configured

if [ "$(stat -c "%a %u %g" /etc/crontab)" == "600 0 0" ]; then
  echo "PASSED: /etc/crontab permissions are correct"
  exit 0
else
  echo "FAILED: /etc/crontab permissions are incorrect"
  exit 1
fi
