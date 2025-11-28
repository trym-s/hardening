#!/bin/bash
# 2.4.5 Ensure permissions on /etc/cron.weekly are configured

chown root:root /etc/cron.weekly
chmod 700 /etc/cron.weekly
