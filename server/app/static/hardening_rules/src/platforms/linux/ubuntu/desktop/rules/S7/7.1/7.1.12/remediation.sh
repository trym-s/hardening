#!/bin/bash

# 7.1.12 Ensure no files or directories without an owner and a group exist (Automated)

echo "Assigning owner and group to files without them..."

# Assign root owner to files without owner
find / -xdev -nouser ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" ! -path "/run/*" -exec chown root {} \; 2>/dev/null

# Assign root group to files without group
find / -xdev -nogroup ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" ! -path "/run/*" -exec chgrp root {} \; 2>/dev/null

echo "Files and directories without owner or group have been assigned to root"
