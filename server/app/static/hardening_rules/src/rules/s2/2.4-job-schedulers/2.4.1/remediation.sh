#!/bin/bash
# 2.4.1 Ensure cron daemon is enabled

systemctl enable cron
systemctl start cron
