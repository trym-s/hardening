#!/bin/bash

# 6.1.2.1.2 Ensure systemd-journal-upload authentication is configured (Manual)

echo "Checking systemd-journal-upload authentication configuration..."

# Check if URL is configured
url=$(grep -E "^URL=" /etc/systemd/journal-upload.conf 2>/dev/null)
# Check if ServerKeyFile is configured
server_key=$(grep -E "^ServerKeyFile=" /etc/systemd/journal-upload.conf 2>/dev/null)
# Check if ServerCertificateFile is configured
server_cert=$(grep -E "^ServerCertificateFile=" /etc/systemd/journal-upload.conf 2>/dev/null)
# Check if TrustedCertificateFile is configured
trusted_cert=$(grep -E "^TrustedCertificateFile=" /etc/systemd/journal-upload.conf 2>/dev/null)

echo "URL: ${url:-Not configured}"
echo "ServerKeyFile: ${server_key:-Not configured}"
echo "ServerCertificateFile: ${server_cert:-Not configured}"
echo "TrustedCertificateFile: ${trusted_cert:-Not configured}"

if [ -n "$url" ] && [ -n "$server_key" ] && [ -n "$server_cert" ] && [ -n "$trusted_cert" ]; then
    echo "PASS: systemd-journal-upload authentication is configured"
    exit 0
else
    echo "FAIL: systemd-journal-upload authentication is not fully configured"
    exit 1
fi
