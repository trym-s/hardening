#!/bin/bash

# 6.2.3.9 Ensure discretionary access control permission modification events are collected (Automated)

echo "Checking if DAC permission modification events are collected..."

syscalls="chmod fchmod fchmodat chown fchown fchownat lchown setxattr lsetxattr fsetxattr removexattr lremovexattr fremovexattr"
all_found=true

for syscall in $syscalls; do
    if ! auditctl -l 2>/dev/null | grep -q "$syscall"; then
        echo "WARNING: $syscall not found in audit rules"
        all_found=false
    fi
done

if $all_found; then
    echo "PASS: DAC permission modifications are being audited"
    exit 0
else
    echo "FAIL: Not all DAC syscalls are being audited"
    exit 1
fi
