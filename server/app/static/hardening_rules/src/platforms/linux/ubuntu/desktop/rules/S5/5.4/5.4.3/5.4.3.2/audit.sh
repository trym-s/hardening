#!/bin/bash

# CIS 5.4.3.2 - Ensure default user shell timeout is configured
# Check TMOUT is configured correctly

echo "Checking shell timeout configuration..."

output1=""
output2=""

[ -f /etc/bashrc ] && BRC="/etc/bashrc"

for f in "$BRC" /etc/profile /etc/profile.d/*.sh; do
    [ ! -f "$f" ] && continue
    
    grep -Pq '^\s*([^#]+\s+)?TMOUT=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9])\b' "$f" && \
    grep -Pq '^\s*([^#]+;\s*)?readonly\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" && \
    grep -Pq '^\s*([^#]+;\s*)?export\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" && \
    output1="$f"
done

# Check for invalid TMOUT values
grep -Pq '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh "$BRC" 2>/dev/null && \
output2=$(grep -Ps '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh $BRC 2>/dev/null)

if [ -n "$output1" ] && [ -z "$output2" ]; then
    echo "PASS: TMOUT is configured in: \"$output1\""
    exit 0
else
    [ -z "$output1" ] && echo "FAIL: TMOUT is not configured"
    [ -n "$output2" ] && echo "FAIL: TMOUT is incorrectly configured in: \"$output2\""
    exit 1
fi
