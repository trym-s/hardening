#!/bin/bash
# CIS 3.1.3 Ensure bluetooth services are not in use

echo "Applying remediation for CIS 3.1.3..."

# Stop bluetooth service if running
if systemctl is-active bluetooth.service 2>/dev/null | grep -q "^active"; then
    systemctl stop bluetooth.service
    echo "Stopped bluetooth.service"
fi

# Disable and mask bluetooth service
if systemctl list-unit-files 2>/dev/null | grep -q "bluetooth.service"; then
    systemctl disable bluetooth.service 2>/dev/null
    systemctl mask bluetooth.service 2>/dev/null
    echo "Disabled and masked bluetooth.service"
fi

# Block bluetooth using rfkill if available
if command -v rfkill &>/dev/null; then
    rfkill block bluetooth 2>/dev/null
    echo "Blocked bluetooth via rfkill"
fi

# Create blacklist file for bluetooth modules
cat > /etc/modprobe.d/disable-bluetooth.conf << 'EOF'
# CIS 3.1.3 - Disable bluetooth modules
install bluetooth /bin/true
install btusb /bin/true
EOF

echo "Created /etc/modprobe.d/disable-bluetooth.conf"
echo ""
echo "Remediation complete for CIS 3.1.3"
echo "NOTE: To fully remove bluetooth, run: apt purge bluez -y"
