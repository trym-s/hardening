#!/bin/bash

# CIS 5.3.3.4.4 - Ensure pam_unix includes use_authtok
# Configure use_authtok for pam_unix

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPERS="${SCRIPT_DIR}/../../common/pam_helpers.sh"

# Source helper functions if available
if [ -f "$HELPERS" ]; then
    source "$HELPERS"
else
    log_info() { echo "[INFO] $1"; }
    log_success() { echo "[SUCCESS] $1"; }
fi

PAM_PASSWORD="/etc/pam.d/common-password"

log_info "pam_unix için use_authtok yapılandırılıyor..."

# Zaten var mı kontrol et (duplicate önleme)
if grep -Pi '^\s*password\s+.*pam_unix\.so.*\buse_authtok\b' "$PAM_PASSWORD" &>/dev/null; then
    log_info "use_authtok zaten yapılandırılmış"
    return 0
fi

# use_authtok ekle
sed -i '/pam_unix.so/s/$/ use_authtok/' "$PAM_PASSWORD"

# Doğrulama
if grep -Pi '^\s*password\s+.*pam_unix\.so.*\buse_authtok\b' "$PAM_PASSWORD" &>/dev/null; then
    log_success "use_authtok yapılandırıldı"
    grep -i pam_unix "$PAM_PASSWORD" | grep password
else
    echo "[ERROR] Yapılandırma başarısız!"
    return 1
fi
