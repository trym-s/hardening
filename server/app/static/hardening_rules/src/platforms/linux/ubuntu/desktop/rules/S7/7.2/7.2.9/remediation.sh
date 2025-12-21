#!/bin/bash

# 7.2.9 Ensure local interactive user home directories are configured (Automated)

echo "Configuring local interactive user home directories..."

# Get list of local interactive users (UID >= 1000 and has a shell)
while IFS=: read -r user uid home shell; do
    if [ "$uid" -ge 1000 ] && [ "$shell" != "/usr/sbin/nologin" ] && [ "$shell" != "/bin/false" ] && [ "$user" != "nobody" ]; then
        # Create home directory if it doesn't exist
        if [ ! -d "$home" ]; then
            echo "Creating home directory $home for user $user"
            mkdir -p "$home"
            cp -r /etc/skel/. "$home/"
        fi

        # Set ownership
        echo "Setting ownership of $home to $user"
        chown -R "$user":"$user" "$home"

        # Set permissions
        echo "Setting permissions of $home to 750"
        chmod 750 "$home"
    fi
done < <(awk -F: '{print $1":"$3":"$6":"$7}' /etc/passwd)

echo "Local interactive user home directories have been configured"
