#!/bin/bash
# CIS Benchmark 1.5.3 - Ensure core dumps are restricted
# Remediation Script

echo "Applying remediation for CIS 1.5.3 - Ensure core dumps are restricted..."

# Remediation 1: Set hard core limit to 0
echo "Setting hard core limit to 0..."
limits_file="/etc/security/limits.d/99-core-dumps.conf"

# Check if already set in limits.conf or limits.d
if ! grep -Pqs -- '^\h*\*\h+hard\h+core\h+0\b' /etc/security/limits.conf /etc/security/limits.d/* 2>/dev/null; then
    echo "* hard core 0" > "$limits_file"
    echo "Created $limits_file with hard core limit set to 0"
else
    echo "Hard core limit is already set to 0"
fi

# Remediation 2: Set fs.suid_dumpable to 0 in durable configuration
echo "Setting fs.suid_dumpable=0 in sysctl configuration..."
sysctl_file="/etc/sysctl.d/60-fs_sysctl.conf"

# Check if already set correctly
if ! grep -Pqs -- '^\h*fs\.suid_dumpable\h*=\h*0\b' /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null; then
    # Create or append to sysctl file
    if [ -f "$sysctl_file" ]; then
        # Remove any existing fs.suid_dumpable entries to avoid conflicts
        sed -i '/^\s*fs\.suid_dumpable/d' "$sysctl_file"
    fi
    echo "fs.suid_dumpable = 0" >> "$sysctl_file"
    echo "Added fs.suid_dumpable=0 to $sysctl_file"
else
    echo "fs.suid_dumpable=0 is already set in durable configuration"
fi

# Remediation 3: Apply kernel parameter immediately
echo "Applying fs.suid_dumpable=0 to running configuration..."
if sysctl -w fs.suid_dumpable=0 > /dev/null 2>&1; then
    echo "Successfully set fs.suid_dumpable=0 in running configuration"
else
    echo "WARNING: Failed to set fs.suid_dumpable=0 in running configuration"
fi

# Remediation 4: Configure systemd-coredump if installed
if systemctl list-unit-files 2>/dev/null | grep -q coredump; then
    echo "systemd-coredump is installed, applying additional configuration..."
    
    coredump_conf="/etc/systemd/coredump.conf"
    coredump_dir="/etc/systemd/coredump.conf.d"
    
    # Create coredump.conf.d directory if it doesn't exist
    if [ ! -d "$coredump_dir" ]; then
        mkdir -p "$coredump_dir"
    fi
    
    # Create override configuration
    override_file="$coredump_dir/99-disable-coredump.conf"
    cat > "$override_file" << 'EOF'
[Coredump]
Storage=none
ProcessSizeMax=0
EOF
    echo "Created $override_file with Storage=none and ProcessSizeMax=0"
    
    # Reload systemd daemon
    if systemctl daemon-reload; then
        echo "Successfully reloaded systemd daemon"
    else
        echo "WARNING: Failed to reload systemd daemon"
    fi
else
    echo "systemd-coredump is not installed, skipping additional configuration"
fi

echo ""
echo "Remediation complete for CIS 1.5.3 - Ensure core dumps are restricted"
echo "Note: A system reboot may be required for all changes to take full effect"
