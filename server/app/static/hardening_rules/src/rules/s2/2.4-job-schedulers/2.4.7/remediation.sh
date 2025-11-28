#!/bin/bash
# 2.4.7 Ensure permissions on /etc/cron.d are configured

chown root:root /etc/cron.d
chmod 700 /etc/cron.d
