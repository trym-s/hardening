#!/bin/bash

# CIS 5.3.3.2.7 - Ensure password quality checking is enforced
# Configure enforcing in pwquality.conf

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

log_info "Parola kalite kontrolü zorlaması etkinleştiriliyor..."

# Dosya yoksa oluştur
if [ ! -f "$PWQUALITY_CONF" ]; then
    touch "$PWQUALITY_CONF"
fi

# Mevcut değeri kontrol et ve güncelle (duplicate önleme)
if grep -qi '^\s*enforcing\s*=' "$PWQUALITY_CONF" 2>/dev/null; then
    current=$(grep -Pi '^\s*enforcing\s*=' "$PWQUALITY_CONF" | grep -oP '\d+')
    if [ "$current" = "0" ]; then
        sed -i 's/^\s*enforcing\s*=.*/enforcing = 1/' "$PWQUALITY_CONF"
        log_info "Güncellendi: enforcing = 1"
    else
        log_info "enforcing zaten aktif: $current"
    fi
elif grep -qi '^#\s*enforcing\s*=' "$PWQUALITY_CONF" 2>/dev/null; then
    sed -i 's/^#\s*enforcing\s*=.*/enforcing = 1/' "$PWQUALITY_CONF"
    log_info "Aktifleştirildi: enforcing = 1"
else
    echo "enforcing = 1" >> "$PWQUALITY_CONF"
    log_info "Eklendi: enforcing = 1"
fi

log_success "Parola kalite kontrolü zorlaması etkinleştirildi"
