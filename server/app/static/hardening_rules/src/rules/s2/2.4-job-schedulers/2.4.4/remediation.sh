#!/bin/bash
# 2.4.4 Ensure permissions on /etc/cron.daily are configured

chown root:root /etc/cron.daily
chmod 700 /etc/cron.daily
