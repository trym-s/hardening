#!/bin/bash
# CIS Benchmark 1.7.10 - Ensure XDMCP is not enabled
# Remediation Script

echo "Applying remediation for CIS 1.7.10 - Ensure XDMCP is not enabled..."

# First check if GDM is installed
if ! dpkg-query -W -f='${db:Status-Status}' gdm3 2>/dev/null | grep -q "installed"; then
    echo "INFO: GDM (gdm3) is not installed"
    echo "      No action needed - this rule is not applicable"
    return 0
fi

echo "GDM is installed, checking and disabling XDMCP..."

# Check and fix each configuration file
files_modified=0

for config_file in /etc/gdm3/custom.conf /etc/gdm3/daemon.conf /etc/gdm/custom.conf /etc/gdm/daemon.conf; do
    if [ -f "$config_file" ]; then
        # Check if [xdmcp] block with Enable=true exists
        if grep -Pziq '\[xdmcp\][^\[]*Enable\s*=\s*true' "$config_file" 2>/dev/null; then
            echo "Found XDMCP enabled in $config_file, disabling..."
            
            # Comment out Enable=true in [xdmcp] block
            # Use awk to process the file
            awk '
                /\[xdmcp\]/ { in_xdmcp = 1 }
                /^\[/ && !/\[xdmcp\]/ { in_xdmcp = 0 }
                in_xdmcp && /^\s*Enable\s*=\s*true/ { 
                    print "# " $0 " # Disabled by CIS remediation"
                    next
                }
                { print }
            ' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            
            echo "Disabled XDMCP in $config_file"
            ((files_modified++))
        else
            echo "INFO: XDMCP is not enabled in $config_file"
        fi
    fi
done

if [ "$files_modified" -eq 0 ]; then
    echo "No changes needed - XDMCP was not enabled in any configuration file"
else
    echo ""
    echo "$files_modified file(s) were modified"
    echo ""
    echo "NOTE: You may need to restart GDM for changes to take effect:"
    echo "      systemctl restart gdm3"
fi

echo ""
echo "Remediation complete for CIS 1.7.10 - Ensure XDMCP is not enabled"
