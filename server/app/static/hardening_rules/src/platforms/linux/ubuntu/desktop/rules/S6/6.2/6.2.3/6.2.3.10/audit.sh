#!/bin/bash

# 6.2.3.10 Ensure successful file system mounts are collected (Automated)

echo "Checking if file system mounts are collected..."

if auditctl -l 2>/dev/null | grep -q "mount"; then
    echo "PASS: File system mounts are being audited"
    auditctl -l 2>/dev/null | grep "mount"
    exit 0
else
    echo "FAIL: File system mounts are not being audited"
    exit 1
fi
