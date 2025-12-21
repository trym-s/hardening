#!/bin/bash

# 6.1.1.2 Ensure journald log file access is configured (Manual)

echo "Checking journald log file access configuration..."

# Check permissions on /var/log/journal directory
if [ -d /var/log/journal ]; then
    journal_perms=$(stat -Lc "%a %u %g" /var/log/journal 2>/dev/null)
    echo "Journal directory permissions: $journal_perms"

    # Check log files in journal directory
    find /var/log/journal -type f -ls

    # Expected: directory should be 2755 or more restrictive, owned by root:systemd-journal
    if [[ "$journal_perms" =~ ^[0-2]755[[:space:]]0[[:space:]][0-9]+ ]]; then
        echo "PASS: Journal directory has appropriate permissions"
        exit 0
    else
        echo "FAIL: Journal directory permissions need review"
        exit 1
    fi
else
    echo "INFO: /var/log/journal directory does not exist (journal may be in memory only)"
    exit 0
fi
