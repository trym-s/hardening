#!/bin/bash
# 2.3.2 Ensure ntp is configured

if [ -f /etc/ntp.conf ]; then
  echo "restrict default kod nomodify notrap nopeer noquery" >> /etc/ntp.conf
  echo "restrict -6 default kod nomodify notrap nopeer noquery" >> /etc/ntp.conf
  systemctl restart ntp
fi
