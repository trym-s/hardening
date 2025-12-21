#!/bin/bash

# CIS 5.4.3.3 - Ensure default user umask is configured
# Check umask is set to 027 or more restrictive

echo "Checking default user umask configuration..."

l_output="" 
l_output2=""

file_umask_chk() {
    if grep -Psiq -- '^\h*umask\h+(0?[0-7][2-7]7|u(=[rwx]{0,3}),g=([rx]{0,2}),o=)(\h*#.*)?$' "$l_file"; then
        l_output="$l_output\n - umask is set correctly in \"$l_file\""
    elif grep -Psiq -- '^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx]{1,3},)?o=[wrx]{1,3}\b)))' "$l_file"; then
        l_output2="$l_output2\n - umask is incorrectly set in \"$l_file\""
    fi
}

# Check /etc/profile.d/*.sh files
while IFS= read -r -d $'\0' l_file; do
    file_umask_chk
done < <(find /etc/profile.d/ -type f -name '*.sh' -print0 2>/dev/null)

# Check other files in order
[ -z "$l_output" ] && l_file="/etc/profile" && [ -f "$l_file" ] && file_umask_chk
[ -z "$l_output" ] && l_file="/etc/bashrc" && [ -f "$l_file" ] && file_umask_chk
[ -z "$l_output" ] && l_file="/etc/bash.bashrc" && [ -f "$l_file" ] && file_umask_chk
[ -z "$l_output" ] && l_file="/etc/login.defs" && [ -f "$l_file" ] && file_umask_chk
[ -z "$l_output" ] && l_file="/etc/default/login" && [ -f "$l_file" ] && file_umask_chk

[[ -z "$l_output" && -z "$l_output2" ]] && l_output2="$l_output2\n - umask is not set"

if [ -z "$l_output2" ]; then
    echo "PASS: Default user umask is correctly configured"
    echo -e "$l_output"
    exit 0
else
    echo "FAIL: Default user umask has issues:"
    echo -e "$l_output2"
    [ -n "$l_output" ] && echo -e "\nCorrectly configured:$l_output"
    exit 1
fi
