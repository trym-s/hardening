#!/bin/bash

# 1.4.2 Ensure permissions on bootloader config are configured (Automated)
# Description: The grub configuration file contains information on boot settings 
# and passwords for unlocking boot options.
# Rationale: Setting the permissions to read and write for root only prevents 
# non-root users from seeing the boot parameters or changing them. Non-root users 
# who read the boot parameters may be able to identify weaknesses in security 
# upon boot and be able to exploit them.

echo "=== 1.4.2 Bootloader Config Permissions Check ==="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
GRUB_CFG="/boot/grub/grub.cfg"
PASSED=0
FAILED=0

# Check if GRUB configuration file exists
if [ ! -f "$GRUB_CFG" ]; then
    echo -e "${RED}[FAIL]${NC} GRUB configuration file not found: $GRUB_CFG"
    echo "Note: GRUB2 may not be installed on your system or may be in a different location."
    exit 1
fi

echo "Checking permissions on $GRUB_CFG..."
echo "Command: stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' $GRUB_CFG"
echo ""

# Get file stats
FILE_STATS=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' "$GRUB_CFG" 2>/dev/null)
echo "Current: $FILE_STATS"
echo "Expected: Access: (0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)"
echo ""

# Get individual values
PERMISSIONS=$(stat -Lc '%a' "$GRUB_CFG" 2>/dev/null)
OWNER_UID=$(stat -Lc '%u' "$GRUB_CFG" 2>/dev/null)
GROUP_GID=$(stat -Lc '%g' "$GRUB_CFG" 2>/dev/null)

# Check 1: Verify Uid is 0 (root)
echo "1. Owner (Uid) Check:"
if [ "$OWNER_UID" == "0" ]; then
    echo -e "   ${GREEN}[PASS]${NC} Owner is root (Uid: 0)"
    ((PASSED++))
else
    echo -e "   ${RED}[FAIL]${NC} Owner is not root (Uid: $OWNER_UID)"
    ((FAILED++))
fi

# Check 2: Verify Gid is 0 (root)
echo ""
echo "2. Group (Gid) Check:"
if [ "$GROUP_GID" == "0" ]; then
    echo -e "   ${GREEN}[PASS]${NC} Group is root (Gid: 0)"
    ((PASSED++))
else
    echo -e "   ${RED}[FAIL]${NC} Group is not root (Gid: $GROUP_GID)"
    ((FAILED++))
fi

# Check 3: Verify permissions are 0600 or more restrictive
echo ""
echo "3. Permissions Check:"
# Permissions should be 0600 or more restrictive (0400, 0000)
if [ "$PERMISSIONS" == "600" ] || [ "$PERMISSIONS" == "400" ] || [ "$PERMISSIONS" == "000" ]; then
    echo -e "   ${GREEN}[PASS]${NC} Permissions are correctly set ($PERMISSIONS)"
    ((PASSED++))
else
    echo -e "   ${RED}[FAIL]${NC} Permissions are too permissive ($PERMISSIONS)"
    echo "   Expected: 600 or more restrictive"
    ((FAILED++))
fi

echo ""
echo "=== Summary ==="
echo -e "${GREEN}Successful Checks: $PASSED${NC}"
echo -e "${RED}Failed Checks: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}Result: COMPLIANT${NC}"
    echo "Bootloader configuration permissions are properly set."
    exit 0
else
    echo -e "${RED}Result: NON-COMPLIANT${NC}"
    echo "Bootloader configuration permissions must be corrected!"
    exit 1
fi
