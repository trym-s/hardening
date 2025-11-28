#!/usr/bin/env bash
# CIS 1.1.1.5 Remediation - Disable jffs2 kernel module

mod_name="jffs2"
conf_dir="/etc/modprobe.d"
conf_file="${conf_dir}/jffs2.conf"
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
    echo "# CIS 1.1.1.5 - Disable jffs2 filesystem"
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