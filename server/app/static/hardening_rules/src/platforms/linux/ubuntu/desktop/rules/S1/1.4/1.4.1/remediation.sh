#!/bin/bash

# CIS Ubuntu 24.04 Benchmark
# 1.4.1 Ensure bootloader password is set (Automated)
# Remediation Script - Non-Interactive Version
#
# NOTE: This rule requires manual intervention to set a GRUB password.
# The script checks current status and provides instructions.
# For security reasons, passwords cannot be set non-interactively.

echo "==========================================="
echo "CIS 1.4.1 - Bootloader Password Status"
echo "==========================================="
echo ""

# Detect GRUB config location
GRUB_CFG=""
for cfg in "/boot/grub/grub.cfg" "/boot/grub2/grub.cfg"; do
    if [ -f "$cfg" ]; then
        GRUB_CFG="$cfg"
        break
    fi
done

if [ -z "$GRUB_CFG" ]; then
    echo "[WARNING] GRUB configuration file not found"
    echo "This system may use a different bootloader"
    return 0
fi

# Check if password is already configured
if grep -q "^set superusers=" "$GRUB_CFG" 2>/dev/null && \
   grep -q "^password_pbkdf2" "$GRUB_CFG" 2>/dev/null; then
    echo "[PASS] Bootloader password is already configured"
    echo ""
    echo "Current configuration:"
    grep "^set superusers=" "$GRUB_CFG" | head -1
    echo "(password hash exists)"
    return 0
fi

# Password not configured - provide instructions
echo "[FAIL] Bootloader password is NOT configured"
echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                    MANUAL ACTION REQUIRED                        ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
echo "This rule requires setting a GRUB bootloader password interactively."
echo "For security reasons, this cannot be automated without user input."
echo ""
echo "To configure manually, run these commands:"
echo ""
echo "  1. Generate password hash:"
echo "     sudo grub-mkpasswd-pbkdf2"
echo ""
echo "  2. Create configuration file:"
echo "     sudo nano /etc/grub.d/40_custom_password"
echo ""
echo "  3. Add the following (replace values with your own):"
echo "     #!/bin/sh"
echo "     exec tail -n +3 \$0"
echo "     set superusers=\"grubadmin\""
echo "     password_pbkdf2 grubadmin <your-hash-here>"
echo ""
echo "  4. Make executable and update GRUB:"
echo "     sudo chmod 755 /etc/grub.d/40_custom_password"
echo "     sudo update-grub"
echo ""
echo "  5. Test by rebooting and pressing 'e' in GRUB menu"
echo ""
echo "WARNING: Store your password securely! If forgotten, you may need"
echo "         a Live CD/USB to recover access to your system."
echo ""

# Return failure to indicate remediation is needed
return 1