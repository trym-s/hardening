#!/bin/bash

# 7.2.2 Ensure /etc/shadow password fields are not empty (Automated)

echo "Locking accounts with empty passwords..."

# Lock accounts with empty passwords
awk -F: '($2 == "") {print $1}' /etc/shadow | while read -r user; do
    echo "Locking user: $user"
    passwd -l "$user"
done

echo "All accounts with empty passwords have been locked"
