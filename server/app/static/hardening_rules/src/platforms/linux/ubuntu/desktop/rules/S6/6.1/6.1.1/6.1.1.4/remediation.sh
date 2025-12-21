#!/bin/bash

# 6.1.1.4 Ensure only one logging system is in use (Automated)

echo "Configuring logging system..."
echo "Choose your logging system:"
echo "1. Use systemd-journald only (disable rsyslog)"
echo "2. Use both with ForwardToSyslog enabled"
echo ""
echo "Manual intervention required to make this decision"
echo ""
echo "To use journald only:"
echo "  systemctl --now disable rsyslog"
echo ""
echo "To use both:"
echo "  Edit /etc/systemd/journald.conf and set ForwardToSyslog=yes"
echo "  systemctl restart systemd-journald"
