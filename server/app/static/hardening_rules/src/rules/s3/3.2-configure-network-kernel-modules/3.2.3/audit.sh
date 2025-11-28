#!/bin/bash
# 3.2.3 Ensure rds kernel module is not available

module="rds"

if modprobe -n -v "$module" 2>/dev/null | grep -q "install /bin/true"; then
    echo "$module is disabled"
else
    echo "$module is not disabled"
    exit 1
fi

if lsmod | grep -q "$module"; then
    echo "$module is loaded"
    exit 1
fi

exit 0
