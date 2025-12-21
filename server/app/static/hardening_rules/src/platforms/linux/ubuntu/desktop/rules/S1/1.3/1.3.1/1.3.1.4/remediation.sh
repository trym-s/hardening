#!/bin/bash
# CIS 1.3.1.4 Remediation - Level 2 (ENFORCE ONLY)

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

# Ensure service is running
if ! systemctl is-active --quiet apparmor; then
    systemctl start apparmor || {
        echo "ERROR: Could not start apparmor service"
        return 1
    }
fi

# Enable service
systemctl enable apparmor >/dev/null 2>&1 || true

# Remove any symlinks from force-complain directory
if [[ -d /etc/apparmor.d/force-complain ]]; then
    echo "Removing profiles from force-complain directory..."
    rm -f /etc/apparmor.d/force-complain/* 2>/dev/null || true
fi

# Set ALL profiles to enforce mode (Level 2 requirement - excluding snap profiles)
echo "Setting profiles to ENFORCE mode (Level 2)..."
for profile in /etc/apparmor.d/*; do
    if [[ -f "$profile" ]]; then
        profile_name=$(basename "$profile")
        # Skip snap profiles
        [[ "$profile_name" == snap.* ]] && continue
        echo "Setting $profile_name to enforce mode."
        aa-enforce "$profile" 2>&1 | grep -v "Warning" || true
    fi
done

# Reload AppArmor
systemctl reload apparmor || true

# Wait a moment for reload to complete
sleep 1

# Verify no complain mode profiles remain
complain=$(apparmor_status 2>/dev/null | grep "profiles are in complain mode" | awk '{print $1}' || echo "0")
if [[ "$complain" -gt 0 ]]; then
    echo "WARNING: $complain profiles still in complain mode"
    echo "Profiles in complain mode:"
    apparmor_status 2>/dev/null | sed -n '/profiles are in complain mode/,/profiles are in enforce mode/p' | grep "^   " || true
else
    echo "SUCCESS: All profiles in enforce mode"
fi

# Check for unconfined processes
unconfined=$(apparmor_status 2>/dev/null | grep "processes are unconfined but have a profile defined" | awk '{print $1}' || echo "0")
if [[ "$unconfined" -gt 0 ]]; then
    echo "WARNING: $unconfined unconfined processes - restart may be required"
    apparmor_status 2>/dev/null | sed -n '/processes are unconfined/,/^$/p' | grep "^   " || true
else
    echo "SUCCESS: All processes confined"
fi

echo "SUCCESS: Level 2 remediation completed"