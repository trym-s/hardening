#!/bin/bash

# CIS 5.4.2.4 - Ensure root account access is controlled
# Verify root account has password set or is locked

echo "Checking root account access control..."

root_status=$(passwd -S root | awk '{print $2}')

case "$root_status" in
    P)
        echo "PASS: Root account has a password set (status: P)"
        exit 0
        ;;
    L)
        echo "PASS: Root account is locked (status: L)"
        exit 0
        ;;
    *)
        echo "FAIL: Root account is not properly secured (status: $root_status)"
        echo "Expected: P (password set) or L (locked)"
        exit 1
        ;;
esac
