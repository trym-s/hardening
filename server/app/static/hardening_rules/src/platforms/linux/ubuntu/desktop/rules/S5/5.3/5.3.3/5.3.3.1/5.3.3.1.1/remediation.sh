#!/bin/bash

# CIS 5.3.3.1.1 - Ensure password failed attempts lockout is configured
# Configure deny parameter in faillock.conf

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPERS="${SCRIPT_DIR}/../../common/pam_helpers.sh"

# Source helper functions if available
if [ -f "$HELPERS" ]; then
    source "$HELPERS"
else
    # Fallback log functions
    log_info() { echo "[INFO] $1"; }
    log_success() { echo "[SUCCESS] $1"; }
    log_error() { echo "[ERROR] $1"; }
fi

FAILLOCK_CONF="/etc/security/faillock.conf"
DENY_VALUE=5

log_info "Parola kilitleme yapılandırılıyor (deny = $DENY_VALUE)..."

# Dosya yoksa oluştur
if [ ! -f "$FAILLOCK_CONF" ]; then
    touch "$FAILLOCK_CONF"
    log_info "Oluşturuldu: $FAILLOCK_CONF"
fi

# Mevcut deny satırını kontrol et ve güncelle (duplicate önleme)
if grep -qi '^\s*deny\s*=' "$FAILLOCK_CONF" 2>/dev/null; then
    # Mevcut değeri güncelle
    sed -i 's/^\s*deny\s*=.*/deny = '"$DENY_VALUE"'/' "$FAILLOCK_CONF"
    log_info "Güncellendi: deny = $DENY_VALUE"
elif grep -qi '^#\s*deny\s*=' "$FAILLOCK_CONF" 2>/dev/null; then
    # Yorum satırını aktifleştir
    sed -i 's/^#\s*deny\s*=.*/deny = '"$DENY_VALUE"'/' "$FAILLOCK_CONF"
    log_info "Aktifleştirildi: deny = $DENY_VALUE"
else
    # Yeni satır ekle
    echo "deny = $DENY_VALUE" >> "$FAILLOCK_CONF"
    log_info "Eklendi: deny = $DENY_VALUE"
fi

# Doğrulama
if grep -qi "^\s*deny\s*=\s*$DENY_VALUE" "$FAILLOCK_CONF"; then
    log_success "Parola kilitleme yapılandırıldı: $DENY_VALUE başarısız denemede hesap kilitlenecek"
else
    log_error "Yapılandırma doğrulanamadı!"
    return 1
fi

echo ""
echo "NOT: Bu ayar pam_faillock modülü etkinleştirildiğinde etkili olacak (5.3.2.2)"
