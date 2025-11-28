#!/usr/bin/env bash
# CIS 1.1.1.10 - Ensure unused filesystems kernel modules are not available

modules=("cramfs" "freevxfs" "hfs" "hfsplus" "jffs2" "squashfs" "udf" "vfat" "nfs")
conf_dir="/etc/modprobe.d"

echo "=== CIS 1.1.1.10 Audit: Checking unused filesystem modules ==="

for mod_name in "${modules[@]}"; do
    echo
    echo "--- Checking ${mod_name} ---"

    # 1. Check if the module exists in the kernel
    if find /lib/modules/$(uname -r) -type f -path "*/fs/${mod_name}/*.ko*" >/dev/null 2>&1; then
        echo "Module ${mod_name} exists in installed kernel modules."

        # 2. Check if module is loaded
        if lsmod | grep -q "^${mod_name}"; then
            echo "FAIL: ${mod_name} module is currently loaded."
        else
            echo "PASS: ${mod_name} module is not loaded."
        fi

        # 3. Check for install /bin/true or /bin/false in modprobe config
        if grep -RPq -- "install\s+${mod_name}\s+(\/usr)?\/bin\/(true|false)" ${conf_dir}/*.conf 2>/dev/null; then
            echo "PASS: install ${mod_name} mapped to /bin/true or /bin/false."
        else
            echo "FAIL: No 'install ${mod_name} /bin/false' or '/bin/true' entry found."
        fi

        # 4. Check for blacklist entry
        if grep -RPq -- "blacklist\s+${mod_name}" ${conf_dir}/*.conf 2>/dev/null; then
            echo "PASS: ${mod_name} is deny-listed."
        else
            echo "FAIL: ${mod_name} is not deny-listed."
        fi
    else
        echo "Module ${mod_name} not found or built directly into kernel."
    fi
done

echo
echo "=== Audit complete for CIS 1.1.1.10 ==="
