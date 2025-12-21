#!/bin/bash
# CIS Benchmark 1.7.4 - Ensure GDM screen locks when the user is idle
# Remediation Script

# Configuration values (can be adjusted according to site policy)
IDLE_DELAY=900    # 15 minutes (900 seconds)
LOCK_DELAY=5      # 5 seconds after screen blanks

echo "Applying remediation for CIS 1.7.4 - Ensure GDM screen locks when the user is idle..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      No action needed - this rule is not applicable"
    return 0
fi

echo "GDM is installed, configuring screen lock settings..."

# Create dconf profile for user
dconf_profile="/etc/dconf/profile/user"
echo "Creating/updating dconf profile at $dconf_profile..."

mkdir -p /etc/dconf/profile
cat > "$dconf_profile" << 'EOF'
user-db:user
system-db:local
EOF

echo "Created dconf profile"

# Create screensaver configuration
screensaver_config_dir="/etc/dconf/db/local.d"
screensaver_config="$screensaver_config_dir/00-screensaver"

echo "Creating screensaver configuration at $screensaver_config..."

mkdir -p "$screensaver_config_dir"
cat > "$screensaver_config" << EOF
[org/gnome/desktop/session]
# Number of seconds of inactivity before the screen goes blank
# Set to 0 seconds if you want to deactivate the screensaver.
idle-delay=uint32 $IDLE_DELAY

[org/gnome/desktop/screensaver]
# Number of seconds after the screen is blank before locking the screen
lock-delay=uint32 $LOCK_DELAY
EOF

echo "Created screensaver configuration"

# Update dconf database
echo "Updating dconf database..."
if command -v dconf &>/dev/null; then
    dconf update
    echo "Successfully updated dconf database"
else
    echo "WARNING: dconf command not found, database not updated"
    echo "         Run 'dconf update' manually after installing dconf"
fi

echo ""
echo "Current configuration:"
echo "----------------------"
echo "dconf profile ($dconf_profile):"
cat "$dconf_profile"
echo ""
echo "Screensaver config ($screensaver_config):"
cat "$screensaver_config"
echo "----------------------"
echo ""
echo "Remediation complete for CIS 1.7.4 - Ensure GDM screen locks when the user is idle"
echo ""
echo "Settings applied:"
echo "  - idle-delay: $IDLE_DELAY seconds ($(($IDLE_DELAY / 60)) minutes)"
echo "  - lock-delay: $LOCK_DELAY seconds"
echo ""
echo "NOTE: Users must log out and back in again for the settings to take effect"
