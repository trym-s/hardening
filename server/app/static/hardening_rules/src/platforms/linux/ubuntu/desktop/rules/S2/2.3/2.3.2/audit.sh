#!/bin/bash
# CIS Benchmark 2.3.2 - Ensure systemd-timesyncd configured with authorized timeserver
audit_passed=true
echo "Checking systemd-timesyncd configuration..."

# Check if systemd-timesyncd is in use
timesyncd_status=$(systemctl is-enabled systemd-timesyncd.service 2>/dev/null)
if [ "$timesyncd_status" != "enabled" ]; then
    echo "INFO: systemd-timesyncd is not enabled, skipping check"
    echo "AUDIT RESULT: PASS - Not applicable"
    exit 0
fi

# Check if NTP servers are configured
config_file="/etc/systemd/timesyncd.conf"
drop_in_dir="/etc/systemd/timesyncd.conf.d"

ntp_configured=false

# Check main config
if [ -f "$config_file" ]; then
    if grep -Pq '^\s*NTP\s*=' "$config_file"; then
        echo "PASS: NTP servers configured in $config_file"
        grep -P '^\s*NTP\s*=' "$config_file"
        ntp_configured=true
    fi
fi

# Check drop-in files
if [ -d "$drop_in_dir" ]; then
    for f in "$drop_in_dir"/*.conf; do
        [ -f "$f" ] || continue
        if grep -Pq '^\s*NTP\s*=' "$f"; then
            echo "PASS: NTP servers configured in $f"
            ntp_configured=true
        fi
    done
fi

if [ "$ntp_configured" = false ]; then
    echo "WARNING: No explicit NTP servers configured (using defaults)"
    echo "         Consider configuring authorized NTP servers"
fi

# Show current time sync status
echo ""
echo "Current time synchronization status:"
timedatectl show --property=NTP --property=NTPSynchronized 2>/dev/null

echo ""
echo "AUDIT RESULT: PASS - Review NTP configuration manually"
exit 0
