#!/bin/bash
cat >> /etc/audit/rules.d/50-delete.rules <<'RULES'
-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat,rmdir -F auid>=1000 -F auid!=unset -k delete
-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat,rmdir -F auid>=1000 -F auid!=unset -k delete
RULES
augenrules --load
