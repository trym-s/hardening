#!/bin/bash

# 6.2.3.3 Ensure events that modify the sudo log file are collected (Automated)

echo "Adding audit rules for sudo log file modifications..."

# Find the sudo log file location
sudo_log=$(grep -r "logfile" /etc/sudoers* 2>/dev/null | grep -v "^#" | awk -F= '{print $2}' | tr -d ' "' | head -1)

if [ -z "$sudo_log" ]; then
    sudo_log="/var/log/sudo.log"
fi

echo "Adding audit rule for: $sudo_log"

cat > /etc/audit/rules.d/50-sudo.rules <<EOF
# Monitor sudo log file
-w $sudo_log -p wa -k sudo_log_file
EOF

# Load the new rules
augenrules --load

echo "Audit rules for sudo log file have been added"
