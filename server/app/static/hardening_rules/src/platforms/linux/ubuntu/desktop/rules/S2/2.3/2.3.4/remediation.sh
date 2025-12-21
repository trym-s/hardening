#!/bin/bash
# CIS Benchmark 2.3.4 - Ensure ntp is configured with authorized timeserver
echo "Applying remediation for CIS 2.3.4..."

# Check if ntp is installed
ntp_status=$(dpkg-query -W -f='${db:Status-Status}' ntp 2>/dev/null)
if [ "$ntp_status" != "installed" ]; then
    echo "INFO: ntp is not installed, skipping"
    return 0
fi

config_file="/etc/ntp.conf"

# Backup original config
if [ -f "$config_file" ]; then
    cp "$config_file" "${config_file}.bak"
fi

# Add NTP servers if not already configured
if ! grep -Eq "^(server|pool).*nist.gov" "$config_file" 2>/dev/null; then
    echo "" >> "$config_file"
    echo "# CIS Benchmark authorized NTP servers" >> "$config_file"
    echo "server time.nist.gov iburst" >> "$config_file"
    echo "pool pool.ntp.org iburst" >> "$config_file"
    echo "Added NTP servers to $config_file"
fi

# Restart ntp if enabled
if systemctl is-enabled ntp.service 2>/dev/null | grep -q "enabled"; then
    echo "Restarting ntp..."
    systemctl restart ntp.service
fi

echo "Remediation complete for CIS 2.3.4"
