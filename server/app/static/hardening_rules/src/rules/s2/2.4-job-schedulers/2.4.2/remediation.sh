#!/bin/bash
# 2.4.2 Ensure permissions on /etc/crontab are configured

chown root:root /etc/crontab
chmod 600 /etc/crontab
