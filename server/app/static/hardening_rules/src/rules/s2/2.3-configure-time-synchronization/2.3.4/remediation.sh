#!/bin/bash
# 2.3.4 Ensure systemd-timesyncd is configured

sed -i 's/#NTP=/NTP=0.ubuntu.pool.ntp.org 1.ubuntu.pool.ntp.org/g' /etc/systemd/timesyncd.conf
sed -i 's/#FallbackNTP=/FallbackNTP=ntp.ubuntu.com/g' /etc/systemd/timesyncd.conf
systemctl restart systemd-timesyncd
