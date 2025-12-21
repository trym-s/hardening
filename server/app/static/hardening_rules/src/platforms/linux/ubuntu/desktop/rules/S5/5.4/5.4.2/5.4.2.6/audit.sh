#!/bin/bash

# CIS 5.4.2.6 - Ensure root user umask is configured
# Check root's umask configuration

echo "Checking root user umask configuration..."

# Check for permissive umask in root shell files
bad_umask=$(grep -Psi -- '^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx]{1,3},)?o=[wrx]{1,3}\b)))' /root/.bash_profile /root/.bashrc 2>/dev/null)

if [ -n "$bad_umask" ]; then
    echo "FAIL: Root has permissive umask configured:"
    echo "$bad_umask"
    exit 1
fi

echo "PASS: Root user umask is correctly configured"
exit 0
