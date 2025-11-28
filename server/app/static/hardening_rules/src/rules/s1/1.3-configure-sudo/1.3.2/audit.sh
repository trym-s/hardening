#!/bin/bash
if grep -q "^Defaults.*use_pty" /etc/sudoers; then
    echo "use_pty is configured"
    exit 0
else
    echo "use_pty is NOT configured"
    exit 1
fi
