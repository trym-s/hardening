#!/bin/bash

# Check permissions on /etc/ssh/sshd_config
actual=$(stat -Lc "%a %u %g" /etc/ssh/sshd_config 2>/dev/null)

if [ "$actual" = "600 0 0" ]; then
    echo "PASS: /etc/ssh/sshd_config has correct permissions (600 0 0)"
    exit 0
else
    echo "FAIL: /etc/ssh/sshd_config has incorrect permissions"
    echo "  Expected: 600 0 0"
    echo "  Actual: $actual"
    exit 1
fi
