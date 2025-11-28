#!/bin/bash
# 2.4.3 Ensure permissions on /etc/cron.hourly are configured

chown root:root /etc/cron.hourly
chmod 700 /etc/cron.hourly
