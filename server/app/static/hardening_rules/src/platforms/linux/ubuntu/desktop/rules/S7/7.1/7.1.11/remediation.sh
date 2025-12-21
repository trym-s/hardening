#!/bin/bash

# 7.1.11 Ensure world writable files and directories are secured (Automated)

echo "Securing world writable files and directories..."

# Remove world write from files
find / -xdev -type f -perm -0002 ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" ! -path "/run/*" -exec chmod o-w {} \; 2>/dev/null

# Add sticky bit to world writable directories or remove world write
find / -xdev -type d -perm -0002 ! -perm -1000 ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" ! -path "/run/*" -exec chmod +t {} \; 2>/dev/null

echo "World writable files and directories have been secured"
