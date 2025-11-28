#!/usr/bin/env bash
# CIS 1.1.2.1 Remediation - Configure /tmp as a separate partition

set -euo pipefail

TMP_DIR="/tmp"
FSTAB_FILE="/etc/fstab"
FSTAB_BACKUP="/etc/fstab.backup-$(date +%Y%m%d-%H%M%S)"

# Calculate tmpfs size:
# - Target: ~25% of RAM
# - Clamp between 512M and 2G to avoid oversizing
calculate_tmpfs_size() {
    local total_ram_kb
    local ram_25_percent
    local size_kb

    total_ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    ram_25_percent=$((total_ram_kb / 4))

    # Alt sınır: 512M (524288 kB)
    # Üst sınır: 2G (2097152 kB)
    if [[ ${ram_25_percent} -lt 524288 ]]; then
        size_kb=524288           # min 512M
    elif [[ ${ram_25_percent} -gt 2097152 ]]; then
        size_kb=2097152          # max 2G
    else
        size_kb=${ram_25_percent}
    fi

    if [[ ${size_kb} -ge 1048576 ]]; then
        echo "$((size_kb / 1048576))G"
    else
        echo "$((size_kb / 1024))M"
    fi
}

TMP_SIZE=$(calculate_tmpfs_size)

echo "=========================================="
echo "CIS 1.1.2.1 Remediation"
echo "Configure /tmp as separate partition"
echo "=========================================="
echo ""

###########################################
# STEP 1: Check if already properly configured
###########################################

# Use same logic as audit script - check TARGET
if command -v findmnt >/dev/null 2>&1; then
    target=$(findmnt -kn -o TARGET "${TMP_DIR}" 2>/dev/null || true)

    if [[ "${target}" == "${TMP_DIR}" ]]; then
        current_source=$(findmnt -kn -o SOURCE "${TMP_DIR}" 2>/dev/null || true)
        current_fstype=$(findmnt -kn -o FSTYPE "${TMP_DIR}" 2>/dev/null || true)

        echo "[INFO] /tmp is already mounted as a separate partition"
        echo "[INFO] Current configuration:"
        echo "  - Target: ${target}"
        echo "  - Source: ${current_source}"
        echo "  - Type: ${current_fstype}"

        # Check if persistent configuration exists
        has_persistent=false

        if grep -qE "^\s*[^#].*\s+/tmp\s+" /etc/fstab 2>/dev/null; then
            echo "  - fstab: configured"
            has_persistent=true
        fi

        if command -v systemctl >/dev/null 2>&1; then
            unit_status=$(systemctl is-enabled tmp.mount 2>&1 || true)
            case "${unit_status}" in
                enabled|generated|static)
                    echo "  - systemd: ${unit_status}"
                    has_persistent=true
                    ;;
                masked)
                    echo "  - systemd: MASKED (needs unmask)"
                    ;;
            esac
        fi

        if [[ "${has_persistent}" == true ]]; then
            echo ""
            echo "[SUCCESS] /tmp is properly configured and persistent"
            exit 0
        else
            echo ""
            echo "[WARNING] /tmp is mounted but not persistent"
            echo "[ACTION] Will ensure persistent configuration..."
        fi
    fi
fi

###########################################
# STEP 2: Unmask tmp.mount if masked
###########################################

if command -v systemctl >/dev/null 2>&1; then
    echo "[SYSTEMD] Checking tmp.mount status..."

    unit_status=$(systemctl is-enabled tmp.mount 2>&1 || true)

    if [[ "${unit_status}" == "masked" ]]; then
        echo "[ACTION] tmp.mount is masked - unmasking it"
        systemctl unmask tmp.mount
        echo "[SUCCESS] tmp.mount unmasked"
    else
        echo "[OK] tmp.mount is not masked (status: ${unit_status})"
    fi
    echo ""
fi

###########################################
# STEP 3: Backup fstab
###########################################

if [[ -f "${FSTAB_FILE}" ]]; then
    cp -p "${FSTAB_FILE}" "${FSTAB_BACKUP}"
    echo "[BACKUP] ${FSTAB_FILE} backed up to ${FSTAB_BACKUP}"
    echo ""
fi

###########################################
# STEP 4: Configure via fstab
###########################################

configure_fstab() {
    echo "[CONFIGURE] Adding tmpfs configuration to /etc/fstab..."

    if grep -qE "^\s*[^#].*\s+/tmp\s+" "${FSTAB_FILE}" 2>/dev/null; then
        echo "[CLEANUP] Removing existing /tmp entries from fstab"
        sed -i.pre-tmp '/^\s*[^#].*\s\+\/tmp\s\+/d' "${FSTAB_FILE}"
    fi

    cat >> "${FSTAB_FILE}" << EOF

# CIS 1.1.2.1 - /tmp as separate partition
# tmpfs provides:
# - Fast RAM-based operation
# - Automatic size management (default: 50% RAM)
# - Volatile storage (cleared on reboot - by design)
# - Configured size: ${TMP_SIZE}
tmpfs   /tmp   tmpfs   defaults,size=${TMP_SIZE}   0   0
EOF

    echo "[SUCCESS] Added tmpfs entry to ${FSTAB_FILE}"
    echo "[INFO] Configuration:"
    echo "  - Type: tmpfs (RAM-based)"
    echo "  - Size: ${TMP_SIZE}"
    echo "  - Volatile: Yes (contents cleared on reboot)"
    echo ""
}

###########################################
# STEP 5: Configure via systemd (alternative)
###########################################

configure_systemd() {
    echo "[CONFIGURE] Creating systemd mount unit..."

    UNIT_FILE="/etc/systemd/system/tmp.mount"
    UNIT_BACKUP="${UNIT_FILE}.backup-$(date +%Y%m%d-%H%M%S)"

    if [[ -f "${UNIT_FILE}" ]]; then
        cp -p "${UNIT_FILE}" "${UNIT_BACKUP}"
        echo "[BACKUP] Existing ${UNIT_FILE} backed up"
    fi

    cat > "${UNIT_FILE}" << EOF
# CIS 1.1.2.1 - /tmp as separate partition
[Unit]
Description=Temporary Directory /tmp
Documentation=man:hier(7)
Documentation=https://www.freedesktop.org/wiki/Software/systemd/APIFileSystems
ConditionPathIsSymbolicLink=!/tmp
DefaultDependencies=no
Conflicts=umount.target
Before=local-fs.target umount.target

[Mount]
What=tmpfs
Where=/tmp
Type=tmpfs
Options=mode=1777,strictatime,size=${TMP_SIZE}

[Install]
WantedBy=local-fs.target
EOF

    echo "[SUCCESS] Created ${UNIT_FILE}"
    echo "[INFO] Configuration:"
    echo "  - Type: tmpfs (RAM-based)"
    echo "  - Size: ${TMP_SIZE}"
    echo "  - Mode: 1777 (world-writable with sticky bit)"
    echo ""

    systemctl daemon-reload
    echo "[SYSTEMD] Configuration reloaded"
}

###########################################
# STEP 6: Mount tmpfs immediately
###########################################

mount_tmpfs_now() {
    echo "[MOUNT] Preparing to mount tmpfs on /tmp..."
    echo ""

    # TMP_BACKUP'u her durumda tanımla ki set -u patlatmasın
    local TMP_BACKUP=""
    
    if [[ -d "${TMP_DIR}" ]] && [[ -n "$(ls -A "${TMP_DIR}" 2>/dev/null)" ]]; then
        TMP_BACKUP="/root/tmp-backup-$(date +%Y%m%d-%H%M%S)"

        echo "[BACKUP] /tmp contains files - backing up to ${TMP_BACKUP}"
        mkdir -p "${TMP_BACKUP}"

        tmp_size=$(du -sh "${TMP_DIR}" 2>/dev/null | awk '{print $1}')
        echo "[INFO] Backing up ${tmp_size} of data..."

        cp -a "${TMP_DIR}"/* "${TMP_BACKUP}/" 2>/dev/null || true
        echo "[SUCCESS] Backup completed"
        echo ""
    fi

    if mountpoint -q "${TMP_DIR}" 2>/dev/null; then
        if command -v findmnt >/dev/null 2>&1; then
            target=$(findmnt -kn -o TARGET "${TMP_DIR}" 2>/dev/null || true)
            if [[ "${target}" == "${TMP_DIR}" ]]; then
                echo "[INFO] /tmp already mounted separately, unmounting to remount"
                umount "${TMP_DIR}" 2>/dev/null || umount -l "${TMP_DIR}" 2>/dev/null || true
            fi
        fi
    fi

    mkdir -p "${TMP_DIR}"
    chmod 1777 "${TMP_DIR}"

    echo "[MOUNT] Mounting tmpfs on /tmp..."
    if mount -t tmpfs -o defaults,size="${TMP_SIZE}" tmpfs "${TMP_DIR}"; then
        echo "[SUCCESS] tmpfs mounted successfully"

        chmod 1777 "${TMP_DIR}"

        if [[ -n "${TMP_BACKUP}" && -d "${TMP_BACKUP}" ]]; then
            echo "[RESTORE] Restoring previous /tmp contents..."
            cp -a "${TMP_BACKUP}"/* "${TMP_DIR}/" 2>/dev/null || true
            echo "[INFO] Contents restored"
            echo "[INFO] Backup retained at: ${TMP_BACKUP}"
        fi

        return 0
    else
        echo "[ERROR] Failed to mount tmpfs"
        echo "[INFO] Changes will take effect after reboot"
        return 1
    fi
}

###########################################
# STEP 7: Main configuration logic
###########################################

echo "[DECISION] Choosing configuration method..."
echo ""

if command -v systemctl >/dev/null 2>&1 && [[ -d /etc/systemd/system ]]; then
    echo "[METHOD] Using systemd mount unit (recommended for systemd systems)"
    echo ""

    configure_systemd

    systemctl enable tmp.mount 2>/dev/null || true
    echo "[SYSTEMD] tmp.mount enabled for automatic mounting"
    echo ""

    echo "[ACTION] Attempting to mount /tmp now..."
    if systemctl start tmp.mount 2>/dev/null; then
        echo "[SUCCESS] tmp.mount started successfully"
    else
        echo "[INFO] Could not start immediately - will be mounted on reboot"
        echo "[ALTERNATIVE] You can also run: mount -a"
    fi

else
    echo "[METHOD] Using /etc/fstab (traditional method)"
    echo ""

    configure_fstab

    if mount_tmpfs_now; then
        echo ""
    else
        echo "[INFO] Run 'mount -a' to mount all fstab entries"
        echo "[INFO] Or reboot the system"
    fi
fi

###########################################
# STEP 8: Verify configuration
###########################################

echo ""
echo "[VERIFY] Checking final configuration..."
echo ""

if command -v findmnt >/dev/null 2>&1; then
    target=$(findmnt -kn -o TARGET "${TMP_DIR}" 2>/dev/null || true)

    if [[ "${target}" == "${TMP_DIR}" ]]; then
        echo "[SUCCESS] /tmp is now mounted as a separate partition"
        echo ""
        echo "[DETAILS]"
        findmnt -n "${TMP_DIR}" 2>/dev/null | sed 's/^/  /'
        echo ""

        df_output=$(df -h "${TMP_DIR}" 2>/dev/null | tail -n 1)
        echo "[CAPACITY]"
        echo "  ${df_output}"

        mount_opts=$(findmnt -kn -o OPTIONS "${TMP_DIR}" 2>/dev/null || true)
        echo ""
        echo "[MOUNT OPTIONS]"
        echo "  ${mount_opts}"
        echo ""
        echo "[NOTE] Additional security options (noexec, nosuid, nodev)"
        echo "       will be configured by separate CIS rules"
    else
        echo "[INFO] /tmp is not yet mounted as separate partition"
        echo "[ACTION] Reboot the system to activate configuration"
        echo "[COMMAND] Or run: mount -a"
    fi
else
    if mountpoint -q "${TMP_DIR}" 2>/dev/null; then
        echo "[SUCCESS] /tmp is mounted"
    else
        echo "[INFO] /tmp will be mounted on next boot"
    fi
fi

echo ""
echo "=========================================="
echo "[RESULT] Configuration completed"
echo ""
echo "SUMMARY:"
echo "  - Partition type: tmpfs (RAM-based)"
echo "  - Configured size: ${TMP_SIZE}"
echo "  - Persistence: /etc/fstab or systemd unit"
echo "  - Volatility: Contents cleared on reboot (by design)"
echo ""
echo "SECURITY BENEFITS:"
echo "  - Isolated from root filesystem"
echo "  - Ready for restrictive mount options"
echo "  - Protected against disk exhaustion"
echo "  - Hard-link attack prevention"
echo "=========================================="
