#!/usr/bin/env bash
set -euo pipefail

TMP_DIR="/tmp"
FSTAB_FILE="/etc/fstab"
FSTAB_BACKUP="/etc/fstab.backup-nosuid-$(date +%Y%m%d-%H%M%S)"

echo "[CHECK] Remediating: ensure nosuid on /tmp"

########################################
# 0) Container / applicability check
########################################

if [ -f /.dockerenv ] || [ -f /run/.containerenv ]; then
    echo "[INFO] Container environment detected, skipping nosuid remediation for /tmp"
    exit 0
fi

########################################
# 1) Runtime mount üzerinde nosuid ekle
########################################

if command -v findmnt >/dev/null 2>&1; then
    mount_opts=$(findmnt -n -o OPTIONS "${TMP_DIR}" 2>/dev/null || true)
else
    mount_opts=$(mount | awk '$3=="/tmp"{gsub(/[()]/,"",$6);print $6}' | head -n1)
fi

if [[ -z "${mount_opts}" ]]; then
    echo "[ERROR] Could not determine /tmp mount options."
    exit 1
fi

if echo "${mount_opts}" | grep -qw nosuid; then
    echo "[INFO] nosuid already present on /tmp runtime mount"
else
    new_opts="${mount_opts},nosuid"
    echo "[ACTION] Remounting /tmp with options: ${new_opts}"
    if mount -o "remount,${new_opts}" "${TMP_DIR}"; then
        echo "[SUCCESS] /tmp remounted with nosuid (runtime)"
    else
        echo "[ERROR] Failed to remount /tmp with nosuid"
        exit 1
    fi
fi

########################################
# 2) /etc/fstab yedeği
########################################

if [[ -f "${FSTAB_FILE}" ]]; then
    cp -p "${FSTAB_FILE}" "${FSTAB_BACKUP}"
    echo "[BACKUP] ${FSTAB_FILE} backed up to ${FSTAB_BACKUP}"
else
    echo "[ERROR] ${FSTAB_FILE} not found."
    exit 1
fi

########################################
# 3) /etc/fstab içinde /tmp satırına nosuid ekle
########################################

# Eğer /tmp için entry yoksa, bu kural ekleme yapmaz; upstream separate-partition kuralını bekler.
if ! grep -Eq '^[[:space:]]*[^#[:space:]]+[[:space:]]+/tmp[[:space:]]+' "${FSTAB_FILE}"; then
    echo "[WARNING] /tmp not found in ${FSTAB_FILE}. Separate partition rule should create it."
    echo "[RESULT] Runtime nosuid ok, fstab için üst kural ihtiyaç duyuluyor."
    exit 2
fi

tmpfile=$(mktemp)

awk -v mp="${TMP_DIR}" '
BEGIN { OFS="\t" }

/^#/ { print; next }

$2 == mp {
    # 4. alan opsiyonlar; boş veya "-" ise defaults yap
    if ($4 == "" || $4 == "-") {
        $4 = "defaults"
    }

    n = split($4, opts, ",")
    has_nosuid = 0
    for (i = 1; i <= n; i++) {
        if (opts[i] == "nosuid") {
            has_nosuid = 1
        }
    }

    if (!has_nosuid) {
        $4 = $4 ",nosuid"
    }

    print
    next
}

{ print }
' "${FSTAB_FILE}" > "${tmpfile}"

mv "${tmpfile}" "${FSTAB_FILE}"

########################################
# 4) İstersen remount fstab üzerinden de tetiklenebilir
########################################

if mountpoint -q "${TMP_DIR}"; then
    echo "[ACTION] Remounting /tmp using updated fstab entry"
    mount -o remount "${TMP_DIR}" || true
fi

########################################
# 5) Son doğrulama
########################################

final_opts=$(findmnt -n -o OPTIONS "${TMP_DIR}" 2>/dev/null || echo "${mount_opts}")

echo "[VERIFY] /tmp mount options after remediation:"
echo "  ${final_opts}"

if echo "${final_opts}" | grep -qw nosuid; then
    echo "[RESULT] PASS: /tmp has nosuid (runtime) and /etc/fstab updated."
    exit 0
else
    echo "[RESULT] WARNING: /etc/fstab updated, but runtime options missing nosuid."
    echo "         Reboot or remount required."
    exit 2
fi
