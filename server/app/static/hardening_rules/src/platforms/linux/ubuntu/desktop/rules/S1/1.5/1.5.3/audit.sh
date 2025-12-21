#!/bin/bash
# CIS Benchmark 1.5.3 - Ensure core dumps are restricted
# Audit Script

audit_passed=true

# Check 1: Verify hard core limit is set to 0
echo "Checking hard core limit..."
if grep -Pqs -- '^\h*\*\h+hard\h+core\h+0\b' /etc/security/limits.conf /etc/security/limits.d/* 2>/dev/null; then
    echo "PASS: Hard core limit is set to 0"
else
    echo "FAIL: Hard core limit is not set to 0"
    audit_passed=false
fi

# Check 2: Verify fs.suid_dumpable is set to 0 in running configuration
echo "Checking fs.suid_dumpable in running configuration..."
running_value=$(sysctl -n fs.suid_dumpable 2>/dev/null)
if [ "$running_value" = "0" ]; then
    echo "PASS: fs.suid_dumpable is correctly set to 0 in running configuration"
else
    echo "FAIL: fs.suid_dumpable is set to '$running_value' in running configuration (should be 0)"
    audit_passed=false
fi

# Check 3: Verify fs.suid_dumpable is set in durable configuration
echo "Checking fs.suid_dumpable in durable configuration..."
durable_set=false
for file in /etc/sysctl.conf /etc/sysctl.d/*.conf; do
    if [ -f "$file" ]; then
        if grep -Pqs -- '^\h*fs\.suid_dumpable\h*=\h*0\b' "$file"; then
            echo "PASS: fs.suid_dumpable=0 is set in $file"
            durable_set=true
            break
        fi
    fi
done

if [ "$durable_set" = false ]; then
    echo "FAIL: fs.suid_dumpable=0 is not set in any sysctl configuration file"
    audit_passed=false
fi

# Check 4: If systemd-coredump is installed, verify its configuration
echo "Checking systemd-coredump configuration..."
if systemctl list-unit-files 2>/dev/null | grep -q coredump; then
    echo "INFO: systemd-coredump is installed, checking configuration..."
    
    storage_ok=false
    processsize_ok=false
    storage_file=""
    processsize_file=""
    
    # Check /etc/systemd/coredump.conf and /etc/systemd/coredump.conf.d/*.conf
    config_files="/etc/systemd/coredump.conf"
    if [ -d "/etc/systemd/coredump.conf.d" ]; then
        config_files="$config_files $(find /etc/systemd/coredump.conf.d -name '*.conf' 2>/dev/null | tr '\n' ' ')"
    fi
    
    for conf_file in $config_files; do
        if [ -f "$conf_file" ]; then
            if grep -Pqs -- '^\h*Storage\h*=\h*none\b' "$conf_file"; then
                storage_ok=true
                storage_file="$conf_file"
            fi
            
            if grep -Pqs -- '^\h*ProcessSizeMax\h*=\h*0\b' "$conf_file"; then
                processsize_ok=true
                processsize_file="$conf_file"
            fi
        fi
    done
    
    if [ "$storage_ok" = true ] && [ "$processsize_ok" = true ]; then
        echo "PASS: systemd-coredump is correctly configured"
        echo "  - Storage=none found in $storage_file"
        echo "  - ProcessSizeMax=0 found in $processsize_file"
    else
        if [ "$storage_ok" = false ]; then
            echo "FAIL: Storage=none is not set in any coredump configuration file"
            audit_passed=false
        fi
        if [ "$processsize_ok" = false ]; then
            echo "FAIL: ProcessSizeMax=0 is not set in any coredump configuration file"
            audit_passed=false
        fi
    fi
else
    echo "INFO: systemd-coredump is not installed (no additional configuration needed)"
fi

# Final result
echo ""
if [ "$audit_passed" = true ]; then
    echo "AUDIT RESULT: PASS - Core dumps are properly restricted"
    exit 0
else
    echo "AUDIT RESULT: FAIL - Core dumps are not properly restricted"
    exit 1
fi
