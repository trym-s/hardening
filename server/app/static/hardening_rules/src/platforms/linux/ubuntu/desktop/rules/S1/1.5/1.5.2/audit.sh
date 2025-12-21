#!/bin/bash
# CIS Benchmark 1.5.2 - Ensure ptrace_scope is restricted (Automated)
# Profile: Level 1 - Server, Level 1 - Workstation
#
# NOTE: Ubuntu ships with /etc/sysctl.d/10-ptrace.conf which sets
# kernel.yama.ptrace_scope = 1 by default (already CIS compliant)

audit_ptrace_scope() {
    local l_output=""
    local l_output2=""
    local l_parameter_name="kernel.yama.ptrace_scope"
    
    # Check running configuration
    local l_running_value
    l_running_value="$(sysctl -n "$l_parameter_name" 2>/dev/null)"
    
    if [ -z "$l_running_value" ]; then
        l_output2="$l_output2\n - Unable to read $l_parameter_name from running configuration (Yama LSM may not be enabled)"
    elif [[ "$l_running_value" =~ ^[123]$ ]]; then
        l_output="$l_output\n - \"$l_parameter_name\" is correctly set to \"$l_running_value\" in the running configuration"
    else
        l_output2="$l_output2\n - \"$l_parameter_name\" is incorrectly set to \"$l_running_value\" in the running configuration (should be 1, 2, or 3)"
    fi
    
    # Check durable settings in configuration files
    local l_file_found=false
    local l_file_value=""
    local l_config_file=""
    
    # Check /etc/sysctl.conf and /etc/sysctl.d/*.conf
    # Only match lines that are NOT commented out (no leading #)
    for l_file in /etc/sysctl.conf /etc/sysctl.d/*.conf; do
        if [ -f "$l_file" ]; then
            # Extract only uncommented lines, get the last occurrence
            local l_match
            l_match="$(grep -E "^[^#]*$l_parameter_name\s*=" "$l_file" 2>/dev/null | tail -1)"
            if [ -n "$l_match" ]; then
                l_file_value="$(echo "$l_match" | awk -F= '{print $2}' | tr -d ' \t')"
                if [ -n "$l_file_value" ]; then
                    l_file_found=true
                    l_config_file="$l_file"
                fi
            fi
        fi
    done
    
    # Check UFW sysctl file if exists
    if [ -f /etc/default/ufw ]; then
        local l_ufwscf
        l_ufwscf="$(awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw | tr -d '"')"
        if [ -n "$l_ufwscf" ] && [ -f "$l_ufwscf" ]; then
            local l_match
            l_match="$(grep -E "^[^#]*$l_parameter_name\s*=" "$l_ufwscf" 2>/dev/null | tail -1)"
            if [ -n "$l_match" ]; then
                local l_ufw_value
                l_ufw_value="$(echo "$l_match" | awk -F= '{print $2}' | tr -d ' \t')"
                if [ -n "$l_ufw_value" ]; then
                    l_file_found=true
                    l_file_value="$l_ufw_value"
                    l_config_file="$l_ufwscf"
                fi
            fi
        fi
    fi
    
    if [ "$l_file_found" = true ]; then
        if [[ "$l_file_value" =~ ^[123]$ ]]; then
            l_output="$l_output\n - \"$l_parameter_name\" is correctly set to \"$l_file_value\" in \"$l_config_file\""
        else
            l_output2="$l_output2\n - \"$l_parameter_name\" is incorrectly set to \"$l_file_value\" in \"$l_config_file\" (should be 1, 2, or 3)"
        fi
    else
        l_output2="$l_output2\n - \"$l_parameter_name\" is not set in any sysctl configuration file"
        l_output2="$l_output2\n   (Note: Check if the value is commented out or file is missing)"
    fi
    
    # Output results
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result: ** PASS **"
        echo -e "$l_output\n"
        return 0
    else
        echo -e "\n- Audit Result: ** FAIL **"
        echo -e " - Reason(s) for audit failure:"
        echo -e "$l_output2"
        if [ -n "$l_output" ]; then
            echo -e "\n- Correctly set:"
            echo -e "$l_output\n"
        fi
        return 1
    fi
}

audit_ptrace_scope
