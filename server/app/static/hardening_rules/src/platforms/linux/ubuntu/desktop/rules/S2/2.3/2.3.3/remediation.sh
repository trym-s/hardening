#!/bin/bash
# CIS Benchmark 2.3.3 - Ensure chrony is configured with authorized timeserver
echo "Applying remediation for CIS 2.3.3..."

# Check if chrony is installed
chrony_status=$(dpkg-query -W -f='${db:Status-Status}' chrony 2>/dev/null)
if [ "$chrony_status" != "installed" ]; then
    echo "INFO: chrony is not installed, skipping"
    return 0
fi

config_file="/etc/chrony/chrony.conf"

# Backup original config
if [ -f "$config_file" ]; then
    cp "$config_file" "${config_file}.bak"
fi

# Add NTP servers if not already configured
if ! grep -Eq "^(server|pool).*nist.gov" "$config_file" 2>/dev/null; then
    echo "" >> "$config_file"
    echo "# CIS Benchmark authorized NTP servers" >> "$config_file"
    echo "pool time.nist.gov iburst" >> "$config_file"
    echo "pool pool.ntp.org iburst" >> "$config_file"
    echo "Added NTP servers to $config_file"
fi

# Restart chrony if enabled
if systemctl is-enabled chrony.service 2>/dev/null | grep -q "enabled"; then
    echo "Restarting chrony..."
    systemctl restart chrony.service
fi

echo "Remediation complete for CIS 2.3.3"
