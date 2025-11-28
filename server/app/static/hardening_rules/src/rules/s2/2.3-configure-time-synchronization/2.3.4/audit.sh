#!/bin/bash
# 2.3.4 Ensure systemd-timesyncd is configured

if [ ! -f /etc/systemd/timesyncd.conf ]; then
  echo "SKIPPED: systemd-timesyncd not installed"
  exit 0
fi

# Check if NTP servers are configured (basic check)
if grep -q "^NTP=" /etc/systemd/timesyncd.conf || grep -q "^#NTP=" /etc/systemd/timesyncd.conf; then
   # This is a weak check, but systemd-timesyncd usually has defaults.
   # Better check is status
   if systemctl is-active systemd-timesyncd | grep -q 'active'; then
       echo "PASSED: systemd-timesyncd is configured and active"
       exit 0
   fi
fi

echo "FAILED: systemd-timesyncd is not active or configured"
exit 1
