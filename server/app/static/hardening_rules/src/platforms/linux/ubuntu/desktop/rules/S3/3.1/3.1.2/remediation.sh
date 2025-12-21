#!/bin/bash
# CIS 3.1.2 Ensure wireless interfaces are disabled

echo "Applying remediation for CIS 3.1.2..."

# Block wireless using rfkill if available
if command -v rfkill &>/dev/null; then
    rfkill block wifi 2>/dev/null
    rfkill block bluetooth 2>/dev/null
    echo "Blocked wifi and bluetooth via rfkill"
else
    echo "rfkill not available"
fi

# Disable common wireless modules
WIRELESS_MODULES="iwlwifi ath9k ath10k_pci rtl8xxxu brcmfmac"

for module in $WIRELESS_MODULES; do
    if lsmod | grep -q "^$module"; then
        modprobe -r "$module" 2>/dev/null && echo "Unloaded module: $module"
    fi
done

# Create blacklist file to prevent loading at boot
cat > /etc/modprobe.d/disable-wireless.conf << 'EOF'
# CIS 3.1.2 - Disable wireless modules
install iwlwifi /bin/true
install ath9k /bin/true
install ath10k_pci /bin/true
install rtl8xxxu /bin/true
install brcmfmac /bin/true
EOF

echo "Created /etc/modprobe.d/disable-wireless.conf"
echo ""
echo "Remediation complete for CIS 3.1.2"
echo "NOTE: A reboot may be required for full effect"
