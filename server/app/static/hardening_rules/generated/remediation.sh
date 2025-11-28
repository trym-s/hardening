#!/usr/bin/env bash
###############################################################################
#
# Generated remediation bundle
#
# Source registry : index.json
# Generated on    : 2025-11-28 14:23:07 UTC
# Rule count      : 4
#
# This script concatenates audit and remediation content for selected rules.
# Each rule block includes its audit instructions followed by remediation steps.
#
###############################################################################

###############################################################################
# BEGIN fix (1 / 4) for '1.1.1.1 1.1.1.1'
###############################################################################
(>&2 echo "Remediating rule 1/4: '1.1.1.1 1.1.1.1'")

# --- Audit ---
#!/usr/bin/env bash
# CIS 1.1.1.1 Audit - Ensure cramfs kernel module is not available

mod_name="cramfs"
conf_dir="/etc/modprobe.d"
conf_file="${conf_dir}/cramfs.conf"
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

# --- Remediation ---
#!/usr/bin/env bash
# CIS 1.1.1.1 Remediation - Disable cramfs kernel module

mod_name="cramfs"
conf_dir="/etc/modprobe.d"
conf_file="${conf_dir}/cramfs.conf"
kernel_ver="$(uname -r)"

echo "[REMEDIATE] Disabling ${mod_name} kernel module..."

# Check if module is built into the kernel
if grep -qw "${mod_name}" "/lib/modules/${kernel_ver}/modules.builtin" 2>/dev/null; then
    echo "[SKIP] ${mod_name} is built into the kernel - cannot be disabled"
    exit 0
fi

# Check if the module exists
if ! find "/lib/modules/${kernel_ver}" -type f -name "${mod_name}.ko*" 2>/dev/null | grep -q .; then
    echo "[SKIP] ${mod_name} module not found on system"
    exit 0
fi

# Create modprobe.d directory if it doesn't exist
if [[ ! -d "${conf_dir}" ]]; then
    mkdir -p "${conf_dir}"
    echo "[CREATED] ${conf_dir} directory"
fi

# Create or update configuration file (idempotent)
{
    echo "# CIS 1.1.1.1 - Disable cramfs filesystem"
    echo "install ${mod_name} /bin/false"
    echo "blacklist ${mod_name}"
} > "${conf_file}"

echo "[CONFIGURED] ${conf_file} created/updated"

# Unload module if currently loaded
if lsmod | grep -qw "^${mod_name}"; then
    if modprobe -r "${mod_name}" 2>/dev/null; then
        echo "[UNLOADED] ${mod_name} module removed from kernel"
    else
        echo "[WARNING] Could not unload ${mod_name} - may be in use (will be disabled on reboot)"
    fi
else
    echo "[OK] ${mod_name} module not currently loaded"
fi

# Update initramfs/initrd if available
if command -v update-initramfs >/dev/null 2>&1; then
    echo "[UPDATE] Updating initramfs..."
    update-initramfs -u -k all >/dev/null 2>&1 || true
elif command -v dracut >/dev/null 2>&1; then
    echo "[UPDATE] Updating initramfs with dracut..."
    dracut -f >/dev/null 2>&1 || true
fi

echo "[SUCCESS] ${mod_name} module has been disabled"

# END fix for '1.1.1.1 1.1.1.1'

###############################################################################
# BEGIN fix (2 / 4) for '2.1.1 2.1.1'
###############################################################################
(>&2 echo "Remediating rule 2/4: '2.1.1 2.1.1'")

# --- Audit ---
#!/bin/bash
if systemctl is-enabled autofs 2>/dev/null | grep -q 'enabled'; then
    echo "autofs is enabled"
    exit 1
else
    echo "autofs is disabled"
    exit 0
fi

# --- Remediation ---
#!/bin/bash
systemctl stop autofs
systemctl disable autofs
apt purge autofs -y

# END fix for '2.1.1 2.1.1'

###############################################################################
# BEGIN fix (3 / 4) for '3.1.1 3.1.1'
###############################################################################
(>&2 echo "Remediating rule 3/4: '3.1.1 3.1.1'")

# --- Audit ---
#!/bin/bash
# 3.1.1 Ensure IPv6 status is identified

# Check if IPv6 is disabled in GRUB
if grep -P "^\s*linux" /boot/grub/grub.cfg 2>/dev/null | grep -q "ipv6.disable=1"; then
    echo "IPv6 is disabled in GRUB"
    exit 0
fi

# Check if IPv6 is disabled via sysctl
if sysctl net.ipv6.conf.all.disable_ipv6 2>/dev/null | grep -q "1" && \
   sysctl net.ipv6.conf.default.disable_ipv6 2>/dev/null | grep -q "1"; then
    echo "IPv6 is disabled via sysctl"
    exit 0
fi

echo "IPv6 status not identified as disabled. Please check manually."
exit 1

# --- Remediation ---
#!/bin/bash
# 3.1.1 Ensure IPv6 status is identified
# Manual remediation required.

echo "Manual remediation required for IPv6 configuration. Please configure GRUB or sysctl to disable IPv6 if required."

# END fix for '3.1.1 3.1.1'

###############################################################################
# BEGIN fix (4 / 4) for '4.2.1 4.2.1'
###############################################################################
(>&2 echo "Remediating rule 4/4: '4.2.1 4.2.1'")

# --- Audit ---
#!/bin/bash
# 4.2.1 Ensure ufw is installed

if dpkg-query -W -f='${Status}' ufw 2>/dev/null | grep -q "install ok installed"; then
    echo "ufw is installed"
    exit 0
else
    echo "ufw is not installed"
    exit 1
fi

# --- Remediation ---
#!/bin/bash
# 4.2.1 Ensure ufw is installed

apt-get install -y ufw

# END fix for '4.2.1 4.2.1'


###############################################################################
# End of generated remediation bundle
###############################################################################
(>&2 echo "Completed rendering 4 rule block(s) from index.json")
