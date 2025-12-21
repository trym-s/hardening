#!/bin/bash
# CIS Benchmark 2.1.8 - Ensure message access agent services are not in use
echo "Applying remediation for CIS 2.1.8..."
systemctl stop dovecot.service 2>/dev/null
systemctl mask dovecot.service 2>/dev/null
apt purge -y dovecot-imapd dovecot-pop3d 2>/dev/null
echo "Remediation complete for CIS 2.1.8"
