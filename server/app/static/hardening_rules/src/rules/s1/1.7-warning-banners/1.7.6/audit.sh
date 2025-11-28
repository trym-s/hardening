#!/bin/bash
if [ "$(stat -c "%a %u %g" /etc/issue.net)" == "644 0 0" ]; then
    echo "Permissions on /etc/issue.net are correct"
    exit 0
else
    echo "Permissions on /etc/issue.net are INCORRECT"
    exit 1
fi
