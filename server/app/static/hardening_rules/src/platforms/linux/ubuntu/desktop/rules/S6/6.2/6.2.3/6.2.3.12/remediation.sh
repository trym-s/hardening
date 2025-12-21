#!/bin/bash
echo "Adding audit rules for login/logout..."
cat >> /etc/audit/rules.d/50-login.rules <<'RULES'
-w /var/log/lastlog -p wa -k logins
-w /var/log/faillog -p wa -k logins
RULES
augenrules --load && echo "Done"
