#!/bin/bash

# CIS 5.4.2.6 - Ensure root user umask is configured
# Set restrictive umask for root user

echo "Configuring root user umask..."

# Files to check
files="/root/.bash_profile /root/.bashrc"

for file in $files; do
    if [ -f "$file" ]; then
        # Remove or comment out permissive umask lines
        if grep -Pqi '^\h*umask\h+' "$file"; then
            sed -i 's/^\(\h*umask\h\+.*\)/#\1 # Commented by CIS remediation/' "$file"
            echo "Commented out existing umask in $file"
        fi
    fi
done

# Add restrictive umask to .bashrc
if [ -f /root/.bashrc ]; then
    if ! grep -q "^umask 0027" /root/.bashrc; then
        echo "" >> /root/.bashrc
        echo "# CIS 5.4.2.6 - Restrictive root umask" >> /root/.bashrc
        echo "umask 0027" >> /root/.bashrc
        echo "Added umask 0027 to /root/.bashrc"
    fi
fi

echo "SUCCESS: Root user umask configured to 0027"
