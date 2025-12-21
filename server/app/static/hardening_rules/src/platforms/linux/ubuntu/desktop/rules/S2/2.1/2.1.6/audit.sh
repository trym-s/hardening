#!/bin/bash
# CIS Benchmark 2.1.6 - Ensure ftp server services are not in use
# Audit Script

audit_passed=true
echo "Checking FTP server services..."

if dpkg-query -W -f='${db:Status-Status}' vsftpd 2>/dev/null | grep -q "installed"; then
    echo "FAIL: vsftpd package is installed"
    audit_passed=false
else
    echo "PASS: vsftpd package is not installed"
fi

if systemctl is-enabled vsftpd.service 2>/dev/null | grep -q "enabled"; then
    echo "FAIL: vsftpd.service is enabled"
    audit_passed=false
else
    echo "PASS: vsftpd.service is not enabled"
fi

echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - FTP server services are not in use"
    exit 0
else
    echo "AUDIT RESULT: FAIL - FTP server services are in use"
    exit 1
fi
