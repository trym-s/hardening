#!/bin/bash
# CIS 1.3.1.2 Remediation - Ensure AppArmor is enabled in bootloader

GRUB_FILE="/etc/default/grub"

# Backup if not already backed up
if [[ ! -f "${GRUB_FILE}.original" ]]; then
    cp "$GRUB_FILE" "${GRUB_FILE}.original" || {
        echo "ERROR: Could not backup grub config"
        return 1
    }
fi

current=$(grep '^GRUB_CMDLINE_LINUX=' "$GRUB_FILE" 2>/dev/null | sed 's/^GRUB_CMDLINE_LINUX="\(.*\)"$/\1/' || echo "")

new="$current"
changed=""

if [[ ! "$new" =~ (^|[[:space:]])apparmor=1([[:space:]]|$) ]]; then
    new="$new apparmor=1"
    changed=1
fi

if [[ ! "$new" =~ (^|[[:space:]])security=apparmor([[:space:]]|$) ]]; then
    new="$new security=apparmor"
    changed=1
fi

if [[ -n "$changed" ]]; then
    new=$(echo "$new" | xargs)
    
    # Update existing line or add new one
    if grep -q '^GRUB_CMDLINE_LINUX=' "$GRUB_FILE"; then
        sed -i "s|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX=\"$new\"|" "$GRUB_FILE"
    else
        echo "GRUB_CMDLINE_LINUX=\"$new\"" >> "$GRUB_FILE"
    fi
    
    # Update GRUB
    if command -v update-grub >/dev/null 2>&1; then
        update-grub 2>/dev/null || true
    elif command -v grub2-mkconfig >/dev/null 2>&1; then
        grub2-mkconfig -o /boot/grub2/grub.cfg 2>/dev/null || \
            grub2-mkconfig -o /boot/grub/grub.cfg 2>/dev/null || true
    fi
    
    echo "SUCCESS: AppArmor bootloader parameters configured. Reboot required."
else
    echo "ALREADY CONFIGURED: AppArmor bootloader parameters already present"
fi