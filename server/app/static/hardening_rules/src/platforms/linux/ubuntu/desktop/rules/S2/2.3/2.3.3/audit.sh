#!/bin/bash
# CIS Benchmark 2.3.3 - Ensure chrony is configured with authorized timeserver
audit_passed=true
echo "Checking chrony configuration..."

# Check if chrony is in use
chrony_status=$(systemctl is-enabled chrony.service 2>/dev/null)
if [ "$chrony_status" != "enabled" ]; then
    echo "INFO: chrony is not enabled, skipping check"
    echo "AUDIT RESULT: PASS - Not applicable"
    exit 0
fi

# Check if NTP servers are configured
config_files="/etc/chrony/chrony.conf /etc/chrony/conf.d/*.conf"
ntp_configured=false

for config_file in $config_files; do
    [ -f "$config_file" ] || continue
    if grep -Eq "^(server|pool)" "$config_file" 2>/dev/null; then
        echo "PASS: NTP servers configured in $config_file"
        grep -E "^(server|pool)" "$config_file"
        ntp_configured=true
    fi
done

if [ "$ntp_configured" = false ]; then
    echo "FAIL: No NTP servers configured for chrony"
    audit_passed=false
fi

# Show synchronization status
echo ""
echo "Chrony sources:"
chronyc sources 2>/dev/null | head -10

echo ""
[ "$audit_passed" = true ] && echo "AUDIT RESULT: PASS" && exit 0 || echo "AUDIT RESULT: FAIL" && exit 1
