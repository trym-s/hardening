#!/bin/bash

# 6.2.3.5 Ensure events that modify the system's network environment are collected (Automated)

echo "Adding audit rules for network environment modifications..."

cat >> /etc/audit/rules.d/50-system_local.rules <<'EOF'
# Monitor network environment changes
-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/network -p wa -k system-locale
-w /etc/netplan -p wa -k system-locale
EOF

# Load the new rules
augenrules --load

echo "Audit rules for network environment modifications have been added"
