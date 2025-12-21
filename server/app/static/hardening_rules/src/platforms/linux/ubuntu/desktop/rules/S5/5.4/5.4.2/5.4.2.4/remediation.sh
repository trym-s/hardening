#!/bin/bash

# CIS 5.4.2.4 - Ensure root account access is controlled
# Set password for root or lock the account

echo "Checking root account status..."

root_status=$(passwd -S root | awk '{print $2}')

case "$root_status" in
    P)
        echo "Root account already has a password set"
        return 0
        ;;
    L)
        echo "Root account is already locked"
        return 0
        ;;
    *)
        echo "Root account is not secured (status: $root_status)"
        echo ""
        echo "Choose an option:"
        echo "  1. Lock root account: usermod -L root"
        echo "  2. Set root password: passwd root"
        echo ""
        echo "Locking root account..."
        usermod -L root
        echo "SUCCESS: Root account has been locked"
        ;;
esac
