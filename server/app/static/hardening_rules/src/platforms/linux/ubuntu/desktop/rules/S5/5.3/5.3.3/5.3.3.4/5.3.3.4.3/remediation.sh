#!/bin/bash

# CIS 5.3.3.4.3 - Ensure pam_unix includes a strong password hashing algorithm
# Configure yescrypt or sha512 for pam_unix

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

log_info "Güçlü parola hash algoritması yapılandırılıyor..."

# Mevcut hash algoritmasını kontrol et
if grep -Pi '^\s*password\s+.*pam_unix\.so.*\b(sha512|yescrypt)\b' "$PAM_PASSWORD" &>/dev/null; then
    current=$(grep -Pi '^\s*password\s+.*pam_unix\.so' "$PAM_PASSWORD" | grep -oE '(sha512|yescrypt)')
    log_info "Güçlü hash algoritması zaten yapılandırılmış: $current"
    return 0
fi

# Eski hash algoritmalarını kaldır (duplicate önleme)
sed -i 's/\s*\bmd5\b//g' "$PAM_PASSWORD"
sed -i 's/\s*\bsha256\b//g' "$PAM_PASSWORD"

# yescrypt zaten var mı kontrol et (duplicate önleme)
if ! grep -Pi '^\s*password\s+.*pam_unix\.so.*\byescrypt\b' "$PAM_PASSWORD" &>/dev/null; then
    # yescrypt ekle
    sed -i '/pam_unix.so/s/$/ yescrypt/' "$PAM_PASSWORD"
    log_info "Eklendi: yescrypt"
fi

# Doğrulama
if grep -Pi '^\s*password\s+.*pam_unix\.so.*\byescrypt\b' "$PAM_PASSWORD" &>/dev/null; then
    log_success "Güçlü hash algoritması (yescrypt) yapılandırıldı"
    grep -i pam_unix "$PAM_PASSWORD" | grep password
else
    log_info "SHA512 ile de kontrol ediliyor..."
    if grep -Pi '^\s*password\s+.*pam_unix\.so.*\bsha512\b' "$PAM_PASSWORD" &>/dev/null; then
        log_success "Güçlü hash algoritması (sha512) yapılandırılmış"
    else
        echo "[ERROR] Yapılandırma başarısız!"
        return 1
    fi
fi

echo ""
echo "NOT: Mevcut parolalar eski algoritma ile şifrelenmiş kalacak."
echo "      Kullanıcılar parola değiştirdiğinde yeni algoritma kullanılacak."
