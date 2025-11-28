#!/bin/bash
if grep -q "Authorized users only" /etc/issue; then
    echo "issue is configured"
    exit 0
else
    echo "issue is NOT configured"
    exit 1
fi
