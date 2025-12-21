#!/usr/bin/env bash
# CIS 1.1.2.1 Audit - Ensure /tmp is a separate partition
#
# RATIONALE:
# /tmp is a world-writable directory used by browsers, editors, and services for temporary files.
# This creates attack opportunities:
# - Attackers can place executable files
# - Hard-link to setuid files to preserve old vulnerable versions
# - Fill disk space causing DoS
#
# Separate partition provides:
# - Isolated mount options (noexec, nosuid, nodev)
# - Protection of root filesystem from disk exhaustion
# - Prevention of hard-link attacks on setuid binaries

# Exit codes
# 0 = PASS (separate partition exists and persistent)
# 1 = FAIL (not a separate partition)
# 2 = WARNING (mounted but not persistent, or masked)

TMP_DIR="/tmp"
audit_result=0
has_runtime_mount=false
has_persistent_config=false

echo "[CHECK] Auditing if /tmp is a separate partition..."
echo ""

###########################################
# STEP 1: Check if /tmp is ACTUALLY mounted as separate partition
###########################################

# Method 1: Use findmnt with TARGET verification (most reliable)
if command -v findmnt >/dev/null 2>&1; then
    # Get the TARGET where /tmp is actually mounted
    target=$(findmnt -kn -o TARGET "${TMP_DIR}" 2>/dev/null)
    
    # CRITICAL: Check if TARGET is exactly /tmp
    # If /tmp is not separate, findmnt returns "/" or another parent mount point
    if [[ "${target}" == "${TMP_DIR}" ]]; then
        has_runtime_mount=true
        
        # Get detailed mount information
        source=$(findmnt -kn -o SOURCE "${TMP_DIR}" 2>/dev/null)
        fstype=$(findmnt -kn -o FSTYPE "${TMP_DIR}" 2>/dev/null)
        size=$(findmnt -kn -o SIZE "${TMP_DIR}" 2>/dev/null)
        
        echo "[PASS] /tmp is mounted as a separate partition"
        echo ""
        echo "[INFO] Mount Information:"
        echo "  Target: ${target}"
        echo "  Source: ${source}"
        echo "  Filesystem: ${fstype}"
        
        # Identify partition type and show characteristics
        if [[ "${fstype}" == "tmpfs" ]]; then
            echo "  Type: tmpfs (RAM-based filesystem)"
            echo ""
            echo "[CHARACTERISTICS]"
            echo "  - Fast: operates in RAM + swap"
            echo "  - Volatile: contents lost on reboot"
            echo "  - Dynamic: size grows/shrinks automatically"
            echo "  - Default size: 50% of physical RAM (unless specified)"
            
            if [[ -n "${size}" ]]; then
                echo "  - Current size: ${size}"
            fi
            
            # Check if size is explicitly configured
            mount_opts=$(findmnt -kn -o OPTIONS "${TMP_DIR}" 2>/dev/null)
            if echo "${mount_opts}" | grep -q "size="; then
                configured_size=$(echo "${mount_opts}" | grep -oP 'size=\K[^,]+')
                echo "  - Size parameter: ${configured_size}"
            else
                echo "  - Size parameter: not set (using 50% RAM default)"
            fi
            
        else
            echo "  Type: Physical/Virtual disk partition (${fstype})"
            echo ""
            echo "[CHARACTERISTICS]"
            echo "  - Persistent: contents survive reboot"
            echo "  - Slower: disk I/O overhead"
            if [[ -n "${size}" ]]; then
                echo "  - Fixed capacity: ${size}"
            fi
        fi
        
    else
        # findmnt succeeded but TARGET is not /tmp (e.g., TARGET is "/")
        echo "[FAIL] /tmp is NOT a separate partition"
        echo "[INFO] /tmp is part of: ${target}"
        has_runtime_mount=false
    fi
fi

# Method 2: Fallback to mountpoint command
if [[ "${has_runtime_mount}" == false ]]; then
    if mountpoint -q "${TMP_DIR}" 2>/dev/null; then
        # mountpoint says it's mounted, verify it's truly separate
        # by checking if /tmp appears in mount output
        if mount | grep -q "on ${TMP_DIR} type"; then
            has_runtime_mount=true
            echo "[PASS] /tmp is mounted as a separate partition (detected via mountpoint)"
            
            mount_entry=$(mount | grep "on ${TMP_DIR} type" | head -n 1)
            echo "[INFO] Mount entry: ${mount_entry}"
        fi
    fi
fi

# Method 3: Final fallback - check /proc/mounts with exact target match
if [[ "${has_runtime_mount}" == false ]]; then
    # Look for lines where the second field (mount point) is exactly /tmp
    if awk '$2 == "/tmp" {found=1; exit} END {exit !found}' /proc/mounts 2>/dev/null; then
        has_runtime_mount=true
        echo "[PASS] /tmp is mounted as a separate partition (detected via /proc/mounts)"
        
        mount_entry=$(awk '$2 == "/tmp" {print; exit}' /proc/mounts)
        echo "[INFO] Mount entry: ${mount_entry}"
    fi
fi

# If no separate partition found at runtime
if [[ "${has_runtime_mount}" == false ]]; then
    echo "[FAIL] /tmp is NOT a separate partition"
    echo ""
    echo "[SECURITY IMPACT]"
    echo "  - No isolation from root filesystem"
    echo "  - Cannot apply restrictive mount options (noexec, nosuid, nodev)"
    echo "  - Vulnerable to disk exhaustion attacks"
    echo "  - Hard-link attacks on setuid binaries possible"
    echo "  - Malicious executable files can be run from /tmp"
    echo ""
    
    # Show diagnostic information
    echo "[DIAGNOSTIC] Current /tmp status:"
    if [[ -d "${TMP_DIR}" ]]; then
        echo "[INFO] /tmp directory exists"
        
        df_output=$(df "${TMP_DIR}" 2>/dev/null | tail -n 1)
        if [[ -n "${df_output}" ]]; then
            parent_fs=$(echo "${df_output}" | awk '{print $1}')
            mount_point=$(echo "${df_output}" | awk '{print $6}')
            echo "[INFO] /tmp is part of: ${parent_fs} (mounted on ${mount_point})"
            echo "[WARNING] /tmp shares space with root filesystem - disk exhaustion risk"
        fi
    else
        echo "[ERROR] /tmp directory does not exist!"
    fi
    
    audit_result=1
fi

###########################################
# STEP 2: Check systemd tmp.mount status (if runtime mount exists)
###########################################

if [[ "${has_runtime_mount}" == true ]] && command -v systemctl >/dev/null 2>&1; then
    echo ""
    echo "[SYSTEMD] Checking tmp.mount unit status..."
    
    # Get unit status - use || true to capture exit code
    unit_status=$(systemctl is-enabled tmp.mount 2>&1 || true)
    
    case "${unit_status}" in
        masked)
            echo "[WARNING] tmp.mount is MASKED"
            echo "[IMPACT] This prevents systemd from managing /tmp mount"
            echo "[ACTION] Run: systemctl unmask tmp.mount"
            audit_result=2
            ;;
        enabled)
            echo "[PASS] tmp.mount is enabled"
            has_persistent_config=true
            ;;
        generated)
            echo "[PASS] tmp.mount is generated from /etc/fstab"
            has_persistent_config=true
            ;;
        static|indirect)
            echo "[INFO] tmp.mount is ${unit_status}"
            has_persistent_config=true
            ;;
        disabled)
            echo "[INFO] tmp.mount is disabled (may be using fstab directly)"
            ;;
        *)
            echo "[INFO] tmp.mount status: ${unit_status}"
            ;;
    esac
fi

###########################################
# STEP 3: Check /etc/fstab for persistence
###########################################

if [[ "${has_runtime_mount}" == true ]]; then
    echo ""
    echo "[PERSISTENCE] Checking /etc/fstab configuration..."
    
    # Look for /tmp entry in fstab (uncommented lines only)
    if grep -E "^\s*[^#].*\s+/tmp\s+" /etc/fstab >/dev/null 2>&1; then
        fstab_entry=$(grep -E "^\s*[^#].*\s+/tmp\s+" /etc/fstab | head -n 1)
        echo "[PASS] /tmp is configured in /etc/fstab"
        echo "[INFO] Entry: ${fstab_entry}"
        has_persistent_config=true
    else
        echo "[INFO] /tmp not found in /etc/fstab"
        
        # If no fstab entry and no systemd unit, this is a problem
        if [[ "${has_persistent_config}" == false ]]; then
            echo "[WARNING] No persistent configuration found"
            echo "[IMPACT] /tmp mount may not persist after reboot"
            echo "[ACTION] Add entry to /etc/fstab or enable systemd unit"
            audit_result=2
        else
            echo "[INFO] Managed by systemd unit (acceptable)"
        fi
    fi
fi

###########################################
# STEP 4: Final compliance determination
###########################################

echo ""
echo "=========================================="

if [[ "${has_runtime_mount}" == false ]]; then
    echo "[RESULT] NON-COMPLIANT (FAIL)"
    echo ""
    echo "ISSUES:"
    echo "  - /tmp is NOT a separate partition"
    echo ""
    echo "ACTION REQUIRED:"
    echo "  - Run remediation script to configure /tmp"
    echo "=========================================="
    exit 1
    
elif [[ "${audit_result}" -eq 2 ]]; then
    echo "[RESULT] PARTIALLY COMPLIANT (WARNING)"
    echo ""
    echo "ISSUES:"
    if [[ "${has_persistent_config}" == false ]]; then
        echo "  - /tmp is mounted but not persistent"
    fi
    
    # Check if masked was detected
    if command -v systemctl >/dev/null 2>&1; then
        unit_status=$(systemctl is-enabled tmp.mount 2>&1 || true)
        if [[ "${unit_status}" == "masked" ]]; then
            echo "  - tmp.mount is masked"
        fi
    fi
    
    echo ""
    echo "ACTION REQUIRED:"
    echo "  - Ensure persistent configuration (fstab or systemd)"
    if command -v systemctl >/dev/null 2>&1; then
        unit_status=$(systemctl is-enabled tmp.mount 2>&1 || true)
        if [[ "${unit_status}" == "masked" ]]; then
            echo "  - Unmask tmp.mount: systemctl unmask tmp.mount"
        fi
    fi
    echo "=========================================="
    exit 2
    
else
    echo "[RESULT] FULLY COMPLIANT (PASS)"
    echo ""
    echo "SUMMARY:"
    echo "  - /tmp is mounted as a separate partition"
    echo "  - Configuration is persistent"
    echo ""
    echo "SECURITY BENEFITS:"
    echo "  - Isolated from root filesystem"
    echo "  - Ready for restrictive mount options"
    echo "  - Protected against disk exhaustion"
    echo "  - Hard-link attack prevention enabled"
    echo "=========================================="
    exit 0
fi