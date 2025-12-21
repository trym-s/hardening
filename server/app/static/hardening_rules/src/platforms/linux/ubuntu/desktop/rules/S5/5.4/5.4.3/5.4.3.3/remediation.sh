#!/bin/bash

# CIS 5.4.3.3 - Ensure default user umask is configured
# Set default umask to 027

echo "Configuring default user umask to 027..."

l_output2=""

# Check for incorrectly configured umask
file_umask_chk() {
    if grep -Psiq -- '^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx]{1,3},)?o=[wrx]{1,3}\b)))' "$l_file"; then
        l_output2="$l_output2\n   - \"$l_file\""
    fi
}

# Check files for incorrect umask
while IFS= read -r -d $'\0' l_file; do
    file_umask_chk
done < <(find /etc/profile.d/ -type f -name '*.sh' -print0 2>/dev/null)

l_file="/etc/profile" && [ -f "$l_file" ] && file_umask_chk
l_file="/etc/bashrc" && [ -f "$l_file" ] && file_umask_chk
l_file="/etc/bash.bashrc" && [ -f "$l_file" ] && file_umask_chk
l_file="/etc/login.defs" && [ -f "$l_file" ] && file_umask_chk
l_file="/etc/default/login" && [ -f "$l_file" ] && file_umask_chk

if [ -n "$l_output2" ]; then
    echo "WARNING: UMASK is not restrictive enough in the following files:"
    echo -e "$l_output2"
    echo ""
    echo "Please update these files and set umask to 0027 or more restrictive"
fi

# Create umask configuration
cat > /etc/profile.d/50-systemwide_umask.sh << 'EOF'
# CIS 5.4.3.3 - Default user umask
umask 027
EOF

echo "SUCCESS: Created /etc/profile.d/50-systemwide_umask.sh with umask 027"
