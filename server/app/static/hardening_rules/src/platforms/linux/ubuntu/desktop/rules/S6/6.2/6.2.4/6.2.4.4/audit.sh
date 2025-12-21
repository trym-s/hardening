#!/bin/bash
echo "Checking audit log directory permissions..."
stat -c "%a" /var/log/audit | grep -q "750" && echo "PASS" && exit 0
echo "FAIL"
exit 1
