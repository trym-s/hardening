#!/bin/bash
echo "Scheduling AIDE filesystem integrity check..."
cat > /etc/cron.daily/aide << 'CRON'
#!/bin/bash
/usr/bin/aide --check
CRON
chmod +x /etc/cron.daily/aide
echo "AIDE has been scheduled to run daily"
