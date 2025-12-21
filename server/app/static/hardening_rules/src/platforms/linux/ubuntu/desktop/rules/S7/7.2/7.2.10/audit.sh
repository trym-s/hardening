#!/bin/bash

# 7.2.10 Ensure local interactive user dot files access is configured (Automated)

echo "Checking local interactive user dot files access..."

failed=0

# Get list of local interactive users (UID >= 1000 and has a shell)
while IFS=: read -r user uid home shell; do
    if [ "$uid" -ge 1000 ] && [ "$shell" != "/usr/sbin/nologin" ] && [ "$shell" != "/bin/false" ] && [ "$user" != "nobody" ]; then
        if [ -d "$home" ]; then
            # Check dot files in home directory
            for file in "$home"/.[!.]*; do
                if [ -f "$file" ]; then
                    # Check if file is group or world writable
                    perm=$(stat -c "%a" "$file" 2>/dev/null)
                    if [ -n "$perm" ]; then
                        # Get last two digits of permission
                        group_other="${perm: -2}"

                        # Check if group writable (second to last digit has write bit)
                        group_perm="${group_other:0:1}"
                        other_perm="${group_other:1:1}"

                        if [ "$group_perm" -ge 2 ] || [ "$other_perm" -ge 2 ]; then
                            echo "FAIL: Dot file $file has permissions $perm (group or world writable)"
                            failed=1
                        fi
                    fi

                    # Check ownership
                    owner=$(stat -c "%U" "$file" 2>/dev/null)
                    if [ "$owner" != "$user" ]; then
                        echo "FAIL: Dot file $file is owned by $owner instead of $user"
                        failed=1
                    fi
                fi
            done

            # Check .netrc specifically - should be 600 or more restrictive
            if [ -f "$home/.netrc" ]; then
                perm=$(stat -c "%a" "$home/.netrc" 2>/dev/null)
                if [ "$perm" != "600" ] && [ "$perm" != "400" ] && [ "$perm" != "000" ]; then
                    echo "FAIL: .netrc file has permissions $perm (should be 600 or more restrictive)"
                    failed=1
                fi
            fi
        fi
    fi
done < <(awk -F: '{print $1":"$3":"$6":"$7}' /etc/passwd)

if [ $failed -eq 0 ]; then
    echo "PASS: All local interactive user dot files are properly configured"
    exit 0
else
    exit 1
fi
