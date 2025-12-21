#!/bin/bash

# 7.2.5 Ensure no duplicate UIDs exist (Automated)

echo "This is a manual remediation task."
echo "Review the duplicate UIDs and assign unique UIDs to each user."
echo ""
echo "To change a user's UID:"
echo "  usermod -u <new_uid> <username>"
echo ""
echo "After changing UID, update file ownership:"
echo "  find / -user <old_uid> -exec chown -h <new_uid> {} \\;"
