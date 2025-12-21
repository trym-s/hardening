#!/bin/bash

# CIS 5.4.3.2 - Ensure default user shell timeout is configured
# Configure TMOUT to 900 seconds (15 minutes)

TMOUT_VALUE=900

echo "Configuring shell timeout to $TMOUT_VALUE seconds..."

# Check and fix existing TMOUT settings in profile.d
for f in /etc/profile.d/*.sh; do
    [ ! -f "$f" ] && continue
    if grep -Pq '^\s*TMOUT=' "$f"; then
        sed -i 's/^\s*TMOUT=.*/#&/' "$f"
        echo "Commented out existing TMOUT in $f"
    fi
done

# Comment out TMOUT in /etc/profile if exists
if [ -f /etc/profile ] && grep -Pq '^\s*TMOUT=' /etc/profile; then
    sed -i 's/^\s*TMOUT=.*/#&/' /etc/profile
    echo "Commented out existing TMOUT in /etc/profile"
fi

# Comment out TMOUT in /etc/bashrc if exists
for brc in /etc/bashrc /etc/bash.bashrc; do
    if [ -f "$brc" ] && grep -Pq '^\s*TMOUT=' "$brc"; then
        sed -i 's/^\s*TMOUT=.*/#&/' "$brc"
        echo "Commented out existing TMOUT in $brc"
    fi
done

# Create new TMOUT configuration
cat > /etc/profile.d/50-tmout.sh << EOF
# CIS 5.4.3.2 - Shell timeout configuration
TMOUT=$TMOUT_VALUE
readonly TMOUT
export TMOUT
EOF

echo "SUCCESS: Shell timeout configured to $TMOUT_VALUE seconds in /etc/profile.d/50-tmout.sh"
