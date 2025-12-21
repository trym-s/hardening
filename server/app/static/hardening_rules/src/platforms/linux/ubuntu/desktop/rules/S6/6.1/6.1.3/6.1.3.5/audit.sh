#!/bin/bash

# 6.1.3.5 Ensure rsyslog logging is configured (Manual)

echo "Checking rsyslog logging configuration..."

echo "=== Main rsyslog configuration ==="
cat /etc/rsyslog.conf 2>/dev/null

echo ""
echo "=== Additional rsyslog configurations ==="
cat /etc/rsyslog.d/*.conf 2>/dev/null

echo ""
echo "Manual review required:"
echo "- Verify that appropriate facilities and priorities are logged"
echo "- Ensure logs are sent to appropriate destinations"
echo "- Check that log rotation is configured"

exit 0
