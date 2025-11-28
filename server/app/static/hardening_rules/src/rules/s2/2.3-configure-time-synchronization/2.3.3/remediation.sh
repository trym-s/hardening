#!/bin/bash
# 2.3.3 Ensure chrony is configured

if [ -f /etc/chrony/chrony.conf ]; then
  if ! grep -q "^user _chrony" /etc/chrony/chrony.conf; then
    echo "user _chrony" >> /etc/chrony/chrony.conf
    systemctl restart chrony
  fi
fi
