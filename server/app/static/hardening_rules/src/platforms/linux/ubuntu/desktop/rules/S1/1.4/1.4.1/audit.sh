#!/bin/bash

# CIS Ubuntu 24.04 Benchmark
# 1.4.1 Ensure bootloader password is set (Automated)
# Profile: Level 1 - Server, Level 1 - Workstation

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Initialize counters
PASSED=0
FAILED=0

echo "======================================"
echo "CIS 1.4.1 - Bootloader Password Audit"
echo "======================================"
echo ""

# Detect GRUB configuration file location
if [ -f "/boot/grub/grub.cfg" ]; then
    GRUB_CFG="/boot/grub/grub.cfg"
elif [ -f "/boot/grub2/grub.cfg" ]; then
    GRUB_CFG="/boot/grub2/grub.cfg"
else
    echo -e "${RED}[FAIL]${NC} GRUB configuration file not found"
    echo "Expected location: /boot/grub/grub.cfg or /boot/grub2/grub.cfg"
    echo "This system may not use GRUB bootloader"
    exit 1
fi

echo "Using GRUB config: $GRUB_CFG"
echo ""

# Check 1: Superuser configuration
echo "Check 1: Superuser Configuration"
echo "---------------------------------------"

SUPERUSER_LINE=$(grep "^set superusers" "$GRUB_CFG" 2>/dev/null)

if [ -n "$SUPERUSER_LINE" ]; then
    # Extract username from the line
    SUPERUSER=$(echo "$SUPERUSER_LINE" | sed 's/^set superusers="\(.*\)"/\1/')
    
    if [ -n "$SUPERUSER" ]; then
        echo -e "${GREEN}[PASS]${NC} Superuser is configured"
        echo "  Found: $SUPERUSER_LINE"
        ((PASSED++))
    else
        echo -e "${RED}[FAIL]${NC} Superuser is defined but empty"
        echo "  Found: $SUPERUSER_LINE"
        ((FAILED++))
    fi
else
    echo -e "${RED}[FAIL]${NC} No superuser configured"
    echo "  Expected: set superusers=\"<username>\""
    ((FAILED++))
fi

echo ""

# Check 2: Password hash configuration
echo "Check 2: Password Hash Configuration"
echo "---------------------------------------"

# Fixed regex: Use grep -E for extended regex or escape properly
# Look for lines starting with optional spaces, then "password"
PASSWORD_LINES=$(grep -E "^[[:space:]]*password" "$GRUB_CFG" 2>/dev/null)

if [ -n "$PASSWORD_LINES" ]; then
    # Check if it's PBKDF2 encrypted
    if echo "$PASSWORD_LINES" | grep -q "password_pbkdf2"; then
        echo -e "${GREEN}[PASS]${NC} PBKDF2 password hash found"
        
        # Show only the password type and username, not the full hash
        echo "$PASSWORD_LINES" | while IFS= read -r line; do
            # Extract username from password line
            PASSWORD_USER=$(echo "$line" | awk '{print $2}')
            echo "  User: $PASSWORD_USER (PBKDF2-SHA512)"
        done
        
        ((PASSED++))
    else
        echo -e "${YELLOW}[WARN]${NC} Password found but not using PBKDF2"
        echo "$PASSWORD_LINES" | sed 's/^/  /'
        echo "  Recommendation: Use grub-mkpasswd-pbkdf2 for strong encryption"
        ((FAILED++))
    fi
else
    echo -e "${RED}[FAIL]${NC} No password configured"
    echo "  Expected: password_pbkdf2 <username> <hash>"
    ((FAILED++))
fi

echo ""

# Additional check: Verify superuser and password user match
if [ -n "$SUPERUSER" ] && [ -n "$PASSWORD_LINES" ]; then
    PASSWORD_USER=$(echo "$PASSWORD_LINES" | grep "password_pbkdf2" | head -1 | awk '{print $2}')
    
    if [ "$SUPERUSER" = "$PASSWORD_USER" ]; then
        echo -e "${GREEN}[INFO]${NC} Superuser and password user match: $SUPERUSER"
    else
        echo -e "${YELLOW}[WARN]${NC} Superuser ($SUPERUSER) and password user ($PASSWORD_USER) mismatch"
        echo "  This may cause authentication issues"
    fi
    echo ""
fi

# Summary
echo "======================================"
echo "Summary"
echo "======================================"
echo -e "Passed checks: ${GREEN}$PASSED${NC}"
echo -e "Failed checks: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}[COMPLIANT]${NC} Bootloader password is properly configured"
    exit 0
else
    echo -e "${RED}[NON-COMPLIANT]${NC} Bootloader password must be configured"
    echo ""
    echo "Remediation required:"
    echo "1. Create encrypted password: grub-mkpasswd-pbkdf2"
    echo "2. Add configuration to /etc/grub.d/40_custom"
    echo "3. Run: update-grub (Debian/Ubuntu) or grub2-mkconfig (RHEL/CentOS)"
    exit 1
fi