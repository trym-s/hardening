#!/bin/bash
# CIS Benchmark 2.3.2 - Ensure systemd-timesyncd configured with authorized timeserver
echo "Applying remediation for CIS 2.3.2..."

# Configuration
NTP_SERVERS="time.nist.gov pool.ntp.org"
FALLBACK_NTP="time.google.com"

config_file="/etc/systemd/timesyncd.conf"

# Backup original config
if [ -f "$config_file" ]; then
    cp "$config_file" "${config_file}.bak"
fi

# Create configuration
cat > "$config_file" << EOF
[Time]
NTP=$NTP_SERVERS
FallbackNTP=$FALLBACK_NTP
EOF

echo "Configured NTP servers:"
cat "$config_file"

# Restart service if enabled
if systemctl is-enabled systemd-timesyncd.service 2>/dev/null | grep -q "enabled"; then
    echo "Restarting systemd-timesyncd..."
    systemctl restart systemd-timesyncd.service
fi

echo ""
echo "Remediation complete for CIS 2.3.2"
