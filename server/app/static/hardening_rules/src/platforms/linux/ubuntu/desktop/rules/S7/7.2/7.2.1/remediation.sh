#!/bin/bash

# 7.2.1 Ensure accounts in /etc/passwd use shadowed passwords (Automated)

echo "Converting accounts to use shadowed passwords..."

# Convert to shadow passwords
pwconv

echo "All accounts have been converted to use shadowed passwords"
