#!/usr/bin/env bash
# CIS 1.1.1.2 Audit - Ensure freevxfs kernel module is not available

mod_name="freevxfs"
conf_dir="/etc/modprobe.d"
conf_file="${conf_dir}/freevxfs.conf"
kernel_ver="$(uname -r)"

# Exit codes for integration
# 0 = PASS, 1 = FAIL, 2 = NOT_APPLICABLE

audit_result=0

# Check if module is built into the kernel
if grep -qw "${mod_name}" "/lib/modules/${kernel_ver}/modules.builtin" 2>/dev/null; then
    echo "[INFO] ${mod_name} is built into the kernel - no action needed"
    exit 2  # Not applicable
fi

# Check if the module exists as a loadable module
if ! find "/lib/modules/${kernel_ver}" -type f -name "${mod_name}.ko*" 2>/dev/null | grep -q .; then
    echo "[INFO] ${mod_name} module not found on system"
    exit 2  # Not applicable
fi

echo "[CHECK] Auditing ${mod_name} kernel module configuration..."

# Check if module is currently loaded
if lsmod | grep -qw "^${mod_name}"; then
    echo "[FAIL] ${mod_name} module is currently loaded"
    audit_result=1
else
    echo "[PASS] ${mod_name} module is not loaded"
fi

# Check for install directive
if grep -Prq "^\s*install\s+${mod_name}\s+/(?:usr/)?bin/(?:true|false)\s*" "${conf_dir}/" 2>/dev/null; then
    echo "[PASS] install directive configured for ${mod_name}"
else
    echo "[FAIL] install directive not configured for ${mod_name}"
    audit_result=1
fi

# Check for blacklist entry
if grep -Prq "^\s*blacklist\s+${mod_name}\s*" "${conf_dir}/" 2>/dev/null; then
    echo "[PASS] ${mod_name} is blacklisted"
else
    echo "[FAIL] ${mod_name} is not blacklisted"
    audit_result=1
fi

exit $audit_result