#!/bin/bash
# 6.2.3.11 Ensure session initiation information is collected (Automated)
echo "Adding audit rules for session initiation..."
cat >> /etc/audit/rules.d/50-session.rules <<'EOF'
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session
EOF
augenrules --load
echo "Session initiation audit rules added"
