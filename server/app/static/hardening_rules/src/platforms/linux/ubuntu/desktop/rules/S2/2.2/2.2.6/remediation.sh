#!/bin/bash
# CIS Benchmark 2.2.6 - Ensure telnet client is not installed
echo "Applying remediation for CIS 2.2.6..."

for pkg in telnet inetutils-telnet; do
    status=$(dpkg-query -W -f='${db:Status-Status}' "$pkg" 2>/dev/null)
    if [ "$status" = "installed" ]; then
        echo "Removing $pkg..."
        apt purge -y "$pkg"
    fi
done

echo "Remediation complete for CIS 2.2.6"
