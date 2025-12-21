#!/bin/bash

# 7.2.10 Ensure local interactive user dot files access is configured (Automated)

echo "Configuring local interactive user dot files access..."

# Get list of local interactive users (UID >= 1000 and has a shell)
while IFS=: read -r user uid home shell; do
    if [ "$uid" -ge 1000 ] && [ "$shell" != "/usr/sbin/nologin" ] && [ "$shell" != "/bin/false" ] && [ "$user" != "nobody" ]; then
        if [ -d "$home" ]; then
            # Fix dot files in home directory
            for file in "$home"/.[!.]*; do
                if [ -f "$file" ]; then
                    echo "Fixing permissions for $file"

                    # Set ownership to user
                    chown "$user":"$user" "$file"

                    # Remove group and other write permissions
                    chmod go-w "$file"
                fi
            done

            # Fix .netrc specifically - should be 600
            if [ -f "$home/.netrc" ]; then
                echo "Setting .netrc to 600"
                chown "$user":"$user" "$home/.netrc"
                chmod 600 "$home/.netrc"
            fi
        fi
    fi
done < <(awk -F: '{print $1":"$3":"$6":"$7}' /etc/passwd)

echo "Local interactive user dot files access has been configured"
