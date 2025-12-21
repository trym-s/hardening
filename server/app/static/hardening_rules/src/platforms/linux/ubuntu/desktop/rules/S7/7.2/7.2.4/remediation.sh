#!/bin/bash

# 7.2.4 Ensure shadow group is empty (Automated)

echo "Removing users from shadow group..."

# Remove all members from shadow group
gpasswd -M "" shadow

# Change primary group for users with shadow as primary group
awk -F: '($4 == "42") {print $1}' /etc/passwd | while read -r user; do
    echo "Changing primary group for user: $user"
    usermod -g users "$user"
done

echo "Shadow group has been emptied"
