#!/bin/bash

# 6.1.3.8 Ensure logrotate is configured (Manual)

echo "Checking logrotate configuration..."

echo "=== Main logrotate configuration ==="
cat /etc/logrotate.conf 2>/dev/null

echo ""
echo "=== Additional logrotate configurations ==="
ls -l /etc/logrotate.d/ 2>/dev/null

echo ""
echo "=== Sample configuration files ==="
head -20 /etc/logrotate.d/* 2>/dev/null

echo ""
echo "Manual review required:"
echo "- Verify that log rotation is configured appropriately"
echo "- Check rotation frequency, retention period, and compression"
echo "- Ensure logs are rotated before filling the disk"

exit 0
