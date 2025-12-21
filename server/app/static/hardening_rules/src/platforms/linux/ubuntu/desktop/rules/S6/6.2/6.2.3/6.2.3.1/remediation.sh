#!/bin/bash

# 6.2.3.1 Ensure changes to system administration scope (sudoers) is collected (Automated)

echo "Adding audit rules for sudoers changes..."

cat >> /etc/audit/rules.d/50-scope.rules <<'EOF'
# Monitor changes to sudoers
-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d/ -p wa -k scope
EOF

# Load the new rules
augenrules --load

echo "Audit rules for sudoers changes have been added"
