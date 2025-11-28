#!/bin/bash
# 4.2.7 Ensure ufw default deny firewall policy

if ufw status verbose | grep -q "Default: deny (incoming), deny (outgoing), disabled (routed)"; then
    echo "Default deny policy is configured"
    exit 0
elif ufw status verbose | grep -q "Default: deny (incoming), allow (outgoing), disabled (routed)"; then
     echo "Default deny incoming policy is configured"
     exit 0
else
    echo "Default deny policy is not configured"
    exit 1
fi
