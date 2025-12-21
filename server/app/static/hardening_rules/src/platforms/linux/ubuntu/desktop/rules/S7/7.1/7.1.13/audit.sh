#!/bin/bash

# 7.1.13 Ensure SUID and SGID files are reviewed (Manual)

echo "Listing SUID and SGID files for review..."

echo "SUID files:"
find / -xdev -type f -perm -4000 ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" ! -path "/run/*" 2>/dev/null

echo ""
echo "SGID files:"
find / -xdev -type f -perm -2000 ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" ! -path "/run/*" 2>/dev/null

echo ""
echo "INFO: This is a manual check. Review the listed files and ensure they are authorized."
echo "INFO: Remove SUID/SGID bit from unauthorized files using: chmod u-s <file> or chmod g-s <file>"
exit 0
