#!/bin/bash
# CIS 1.3.1.3 Remediation - Ensure AppArmor profiles are in enforce or complain mode

# Check for root
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Must run as root"
    return 1
fi

# Install utils if needed
if ! command -v aa-enforce >/dev/null 2>&1; then
    apt-get install -y apparmor-utils >/dev/null 2>&1 || {
        echo "ERROR: Could not install apparmor-utils"
        return 1
    }
fi

# Start service if not running
if ! systemctl is-active --quiet apparmor; then
    systemctl start apparmor || {
        echo "ERROR: Could not start apparmor service"
        return 1
    }
fi

# Enable service
systemctl enable apparmor >/dev/null 2>&1 || true

# Set all profiles to enforce mode
echo "Setting profiles to enforce mode..."
aa-enforce /etc/apparmor.d/* 2>&1 | grep -v "Warning" || true

# Reload
systemctl reload apparmor || true

# Check for unconfined
unconfined=$(apparmor_status 2>/dev/null | grep "processes are unconfined but have a profile defined" | awk '{print $1}' || echo "0")

if [[ "$unconfined" -gt 0 ]]; then
    echo "WARNING: $unconfined unconfined processes - restart may be required"
    apparmor_status 2>/dev/null | grep -A 20 "processes are unconfined" | grep "^   " || true
else
    echo "SUCCESS: All processes confined"
fi

echo "SUCCESS: Remediation completed"