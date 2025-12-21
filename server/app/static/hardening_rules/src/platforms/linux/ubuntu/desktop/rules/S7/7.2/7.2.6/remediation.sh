#!/bin/bash

# 7.2.6 Ensure no duplicate GIDs exist (Automated)

echo "This is a manual remediation task."
echo "Review the duplicate GIDs and assign unique GIDs to each group."
echo ""
echo "To change a group's GID:"
echo "  groupmod -g <new_gid> <groupname>"
echo ""
echo "After changing GID, update file ownership:"
echo "  find / -group <old_gid> -exec chgrp -h <new_gid> {} \\;"
