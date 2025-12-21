#!/bin/bash
# CIS Benchmark 1.7.7 - Ensure GDM disabling automatic mounting of removable media is not overridden
# Remediation Script

echo "Applying remediation for CIS 1.7.7 - Ensure GDM disabling automatic mounting of removable media is not overridden..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      No action needed - this rule is not applicable"
    return 0
fi

echo "GDM is installed, configuring automatic mounting override prevention..."

# Create locks directory
locks_dir="/etc/dconf/db/local.d/locks"
locks_file="$locks_dir/00-media-automount"

echo "Creating locks directory at $locks_dir..."
mkdir -p "$locks_dir"

echo "Creating locks configuration at $locks_file..."
cat > "$locks_file" << 'EOF'
# Lock automatic mounting settings
/org/gnome/desktop/media-handling/automount
/org/gnome/desktop/media-handling/automount-open
EOF

echo "Created locks configuration"

# Ensure user profile exists (required for locks to work)
dconf_profile="/etc/dconf/profile/user"
if [ ! -f "$dconf_profile" ]; then
    echo "Creating dconf profile at $dconf_profile..."
    mkdir -p /etc/dconf/profile
    cat > "$dconf_profile" << 'EOF'
user-db:user
system-db:local
EOF
    echo "Created dconf profile"
else
    echo "dconf profile already exists at $dconf_profile"
fi

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
echo "Locks file ($locks_file):"
cat "$locks_file"
echo "----------------------"
echo ""
echo "Remediation complete for CIS 1.7.7 - Ensure GDM disabling automatic mounting of removable media is not overridden"
echo ""
echo "NOTE: Users must log out and back in again for the settings to take effect"
