#!/bin/bash
# CIS Benchmark 2.3.1 - Ensure time synchronization is in use
echo "Applying remediation for CIS 2.3.1..."

# Check if any time sync service is already enabled
timesyncd_status=$(systemctl is-enabled systemd-timesyncd.service 2>/dev/null)
chrony_status=$(systemctl is-enabled chrony.service 2>/dev/null)

if [ "$timesyncd_status" = "enabled" ] || [ "$chrony_status" = "enabled" ]; then
    echo "Time synchronization is already enabled"
else
    # Enable systemd-timesyncd by default
    echo "Enabling systemd-timesyncd..."
    systemctl unmask systemd-timesyncd.service 2>/dev/null
    systemctl enable --now systemd-timesyncd.service
    echo "systemd-timesyncd.service enabled and started"
fi

echo "Remediation complete for CIS 2.3.1"
