#!/bin/bash

# 6.2.3.6 Ensure use of privileged commands are collected (Automated)

source "$(dirname "$0")/../../../common/audit_helpers.sh" 2>/dev/null || true

echo "Finding and adding audit rules for privileged commands..."

find_privileged_commands "/etc/audit/rules.d/50-privileged.rules"

reload_audit_rules

echo "Privileged command audit rules have been added"
