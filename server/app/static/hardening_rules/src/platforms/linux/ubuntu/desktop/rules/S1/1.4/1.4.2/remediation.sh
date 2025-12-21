#!/bin/bash

# 1.4.2 Ensure permissions on bootloader config are configured (Automated)
# Remediation: Set correct ownership and permissions on grub configuration file

echo "=== 1.4.2 Bootloader Config Permissions Remediation ==="
echo ""

# Check possible GRUB config locations
GRUB_CFG=""
for cfg in "/boot/grub/grub.cfg" "/boot/grub2/grub.cfg" "/boot/efi/EFI/*/grub.cfg"; do
    if [ -f "$cfg" ]; then
        GRUB_CFG="$cfg"
        break
    fi
done

# Check if GRUB configuration file exists
if [ -z "$GRUB_CFG" ] || [ ! -f "$GRUB_CFG" ]; then
    echo "[WARNING] GRUB configuration file not found"
    echo "Checked: /boot/grub/grub.cfg, /boot/grub2/grub.cfg"
    echo "Note: GRUB2 may not be installed or configured differently"
    return 0  # Not an error, might be a different bootloader
fi

echo "Found GRUB config: $GRUB_CFG"
echo ""
echo "Current permissions:"
stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' "$GRUB_CFG"
echo ""

echo "Applying remediation..."
echo ""

# Set ownership to root:root
echo "1. Setting ownership to root:root..."
if chown root:root "$GRUB_CFG"; then
    echo "   [OK] Ownership set successfully"
else
    echo "   [ERROR] Failed to set ownership"
    return 1
fi

# Set permissions to 0600
echo "2. Setting permissions to 0600..."
if chmod u-x,go-rwx "$GRUB_CFG"; then
    echo "   [OK] Permissions set successfully"
else
    echo "   [ERROR] Failed to set permissions"
    return 1
fi

echo ""
echo "New permissions:"
stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' "$GRUB_CFG"
echo ""
echo "[SUCCESS] Remediation completed successfully."
