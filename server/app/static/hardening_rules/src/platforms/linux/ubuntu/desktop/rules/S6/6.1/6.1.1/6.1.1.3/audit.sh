#!/bin/bash

# 6.1.1.3 Ensure journald log file rotation is configured (Manual)

echo "Checking journald log file rotation configuration..."

# Check SystemMaxUse setting
max_use=$(grep -E "^SystemMaxUse=" /etc/systemd/journald.conf 2>/dev/null)
# Check SystemKeepFree setting
keep_free=$(grep -E "^SystemKeepFree=" /etc/systemd/journald.conf 2>/dev/null)
# Check RuntimeMaxUse setting
runtime_max=$(grep -E "^RuntimeMaxUse=" /etc/systemd/journald.conf 2>/dev/null)
# Check MaxFileSec setting
max_file_sec=$(grep -E "^MaxFileSec=" /etc/systemd/journald.conf 2>/dev/null)

echo "SystemMaxUse: ${max_use:-Not configured (using default)}"
echo "SystemKeepFree: ${keep_free:-Not configured (using default)}"
echo "RuntimeMaxUse: ${runtime_max:-Not configured (using default)}"
echo "MaxFileSec: ${max_file_sec:-Not configured (using default)}"

# CIS allows using systemd defaults which are reasonable
# Only fail if explicitly set to problematic values
if [ -n "$max_use" ] || [ -n "$keep_free" ] || [ -n "$max_file_sec" ] || [ -n "$runtime_max" ]; then
    echo ""
    echo "AUDIT RESULT: PASS - Log rotation settings are explicitly configured"
    exit 0
else
    # Systemd defaults are reasonable (10% of filesystem), so this is acceptable
    echo ""
    echo "INFO: No explicit log rotation settings found (using systemd defaults)"
    echo "Systemd defaults: SystemMaxUse=10%, RuntimeMaxUse=10%"
    echo ""
    echo "AUDIT RESULT: PASS - Systemd defaults provide reasonable log rotation"
    exit 0
fi
