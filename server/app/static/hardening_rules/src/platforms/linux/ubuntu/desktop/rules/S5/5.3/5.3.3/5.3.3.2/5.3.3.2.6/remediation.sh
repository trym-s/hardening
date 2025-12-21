#!/bin/bash

# CIS 5.3.3.2.6 - Ensure password dictionary check is enabled
# Configure dictcheck in pwquality.conf

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPERS="${SCRIPT_DIR}/../../common/pam_helpers.sh"

# Source helper functions if available
if [ -f "$HELPERS" ]; then
    source "$HELPERS"
else
    log_info() { echo "[INFO] $1"; }
    log_success() { echo "[SUCCESS] $1"; }
fi

PWQUALITY_CONF="/etc/security/pwquality.conf"

log_info "Sözlük kontrolü etkinleştiriliyor..."

# Dosya yoksa oluştur
if [ ! -f "$PWQUALITY_CONF" ]; then
    touch "$PWQUALITY_CONF"
fi

# Mevcut değeri kontrol et ve güncelle (duplicate önleme)
if grep -qi '^\s*dictcheck\s*=' "$PWQUALITY_CONF" 2>/dev/null; then
    # dictcheck = 0 ise 1 yap, diğer değerleri koru
    current=$(grep -Pi '^\s*dictcheck\s*=' "$PWQUALITY_CONF" | grep -oP '\d+')
    if [ "$current" = "0" ]; then
        sed -i 's/^\s*dictcheck\s*=.*/dictcheck = 1/' "$PWQUALITY_CONF"
        log_info "Güncellendi: dictcheck = 1"
    else
        log_info "dictcheck zaten aktif: $current"
    fi
elif grep -qi '^#\s*dictcheck\s*=' "$PWQUALITY_CONF" 2>/dev/null; then
    # Yorum satırını aktifleştir
    sed -i 's/^#\s*dictcheck\s*=.*/dictcheck = 1/' "$PWQUALITY_CONF"
    log_info "Aktifleştirildi: dictcheck = 1"
else
    # Yeni satır ekle
    echo "dictcheck = 1" >> "$PWQUALITY_CONF"
    log_info "Eklendi: dictcheck = 1"
fi

log_success "Sözlük kontrolü etkinleştirildi"
