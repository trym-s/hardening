#!/bin/bash
# 2.4.6 Ensure permissions on /etc/cron.monthly are configured

chown root:root /etc/cron.monthly
chmod 700 /etc/cron.monthly
