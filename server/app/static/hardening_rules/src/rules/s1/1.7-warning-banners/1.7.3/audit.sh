#!/bin/bash
if grep -q "Authorized users only" /etc/issue.net; then
    echo "issue.net is configured"
    exit 0
else
    echo "issue.net is NOT configured"
    exit 1
fi
