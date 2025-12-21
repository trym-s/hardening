#!/bin/bash
# CIS 3.2.4 Ensure sctp kernel module is not available

MODULE="sctp"

echo "Applying remediation for CIS 3.2.4..."

# Create modprobe configuration file
cat > /etc/modprobe.d/${MODULE}.conf << EOF
# CIS 3.2.4 - Disable $MODULE module
install $MODULE /bin/true
blacklist $MODULE
EOF

echo "Created /etc/modprobe.d/${MODULE}.conf"

# Unload module if currently loaded
if lsmod | grep -q "^$MODULE"; then
    modprobe -r "$MODULE" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Unloaded $MODULE module"
    else
        echo "WARNING: Could not unload $MODULE module (may be in use)"
    fi
else
    echo "$MODULE module is not currently loaded"
fi

echo "Remediation complete for CIS 3.2.4"
