#!/bin/bash
# CIS Benchmark 2.1.1 - Ensure autofs services are not in use
# Remediation Script

echo "Applying remediation for CIS 2.1.1 - Ensure autofs services are not in use..."

# Stop autofs service if running
if systemctl is-active autofs.service 2>/dev/null | grep -q "^active"; then
    echo "Stopping autofs.service..."
    systemctl stop autofs.service
fi

# Mask autofs service
echo "Masking autofs.service..."
systemctl mask autofs.service 2>/dev/null

# Remove autofs package if installed
if dpkg-query -W -f='${db:Status-Status}' autofs 2>/dev/null | grep -q "installed"; then
    echo "Removing autofs package..."
    apt purge -y autofs
fi

echo ""
echo "Remediation complete for CIS 2.1.1 - Ensure autofs services are not in use"
