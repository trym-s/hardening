#!/usr/bin/env bash

# 1.5.1 Ensure address space layout randomization is enabled (Automated)
# Remediation: Set kernel.randomize_va_space = 2 in sysctl configuration
# Description: ASLR is an exploit mitigation technique which randomly arranges 
# the address space of key data areas of a process.

echo "=== 1.5.1 ASLR Remediation ==="
echo ""

SYSCTL_CONF="/etc/sysctl.d/60-kernel_sysctl.conf"
PARAM_NAME="kernel.randomize_va_space"
PARAM_VALUE="2"

echo "Setting $PARAM_NAME = $PARAM_VALUE"
echo ""

# Check current running value
echo "1. Current running configuration:"
CURRENT_VALUE=$(sysctl -n "$PARAM_NAME" 2>/dev/null)
echo "   $PARAM_NAME = $CURRENT_VALUE"
echo ""

# Set the parameter in configuration file
echo "2. Setting durable configuration in $SYSCTL_CONF..."

# Create the file if it doesn't exist, or update if it does
if [ -f "$SYSCTL_CONF" ]; then
    # Check if the parameter already exists in the file
    if grep -q "^$PARAM_NAME" "$SYSCTL_CONF"; then
        # Update existing parameter
        sed -i "s/^$PARAM_NAME.*/$PARAM_NAME = $PARAM_VALUE/" "$SYSCTL_CONF"
        echo "   [OK] Updated existing parameter in $SYSCTL_CONF"
    else
        # Append the parameter
        printf "%s\n" "$PARAM_NAME = $PARAM_VALUE" >> "$SYSCTL_CONF"
        echo "   [OK] Added parameter to $SYSCTL_CONF"
    fi
else
    # Create new file with the parameter
    printf "%s\n" "$PARAM_NAME = $PARAM_VALUE" >> "$SYSCTL_CONF"
    echo "   [OK] Created $SYSCTL_CONF with parameter"
fi

# Apply the setting to the running kernel
echo ""
echo "3. Applying to running kernel..."
sysctl -w "$PARAM_NAME=$PARAM_VALUE"
if [ $? -eq 0 ]; then
    echo "   [OK] Applied successfully"
else
    echo "   [ERROR] Failed to apply kernel parameter"
    return 1
fi

# Verify
echo ""
echo "4. Verification:"
NEW_VALUE=$(sysctl -n "$PARAM_NAME" 2>/dev/null)
echo "   $PARAM_NAME = $NEW_VALUE"

if [ "$NEW_VALUE" = "$PARAM_VALUE" ]; then
    echo ""
    echo "[SUCCESS] ASLR is now enabled with value $PARAM_VALUE"
else
    echo ""
    echo "[ERROR] Failed to set ASLR value"
    return 1
fi
