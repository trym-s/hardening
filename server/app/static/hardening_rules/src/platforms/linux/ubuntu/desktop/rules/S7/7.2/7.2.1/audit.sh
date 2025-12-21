#!/bin/bash

# 7.2.1 Ensure accounts in /etc/passwd use shadowed passwords (Automated)

echo "Checking if all accounts in /etc/passwd use shadowed passwords..."

# Check for accounts with password in /etc/passwd (should be 'x')
non_shadowed=$(awk -F: '($2 != "x" && $2 != "*" && $2 != "!") {print $1":"$2}' /etc/passwd)

if [ -z "$non_shadowed" ]; then
    echo "PASS: All accounts use shadowed passwords"
    exit 0
else
    echo "FAIL: Found accounts not using shadowed passwords:"
    echo "$non_shadowed"
    exit 1
fi
