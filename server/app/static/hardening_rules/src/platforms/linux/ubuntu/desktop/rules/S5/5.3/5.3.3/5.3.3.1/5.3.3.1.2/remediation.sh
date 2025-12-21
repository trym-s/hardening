#!/bin/bash

# CIS 5.3.3.1.2 - Ensure password unlock time is configured
# Configure unlock_time parameter in faillock.conf

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
UNLOCK_TIME=900  # 15 dakika

log_info "Parola kilit açma süresi yapılandırılıyor (unlock_time = $UNLOCK_TIME saniye)..."

# Dosya yoksa oluştur
if [ ! -f "$FAILLOCK_CONF" ]; then
    touch "$FAILLOCK_CONF"
    log_info "Oluşturuldu: $FAILLOCK_CONF"
fi

# Mevcut unlock_time satırını kontrol et ve güncelle (duplicate önleme)
if grep -qi '^\s*unlock_time\s*=' "$FAILLOCK_CONF" 2>/dev/null; then
    sed -i 's/^\s*unlock_time\s*=.*/unlock_time = '"$UNLOCK_TIME"'/' "$FAILLOCK_CONF"
    log_info "Güncellendi: unlock_time = $UNLOCK_TIME"
elif grep -qi '^#\s*unlock_time\s*=' "$FAILLOCK_CONF" 2>/dev/null; then
    sed -i 's/^#\s*unlock_time\s*=.*/unlock_time = '"$UNLOCK_TIME"'/' "$FAILLOCK_CONF"
    log_info "Aktifleştirildi: unlock_time = $UNLOCK_TIME"
else
    echo "unlock_time = $UNLOCK_TIME" >> "$FAILLOCK_CONF"
    log_info "Eklendi: unlock_time = $UNLOCK_TIME"
fi

# Doğrulama
if grep -qi "^\s*unlock_time\s*=\s*$UNLOCK_TIME" "$FAILLOCK_CONF"; then
    log_success "Kilit açma süresi yapılandırıldı: $UNLOCK_TIME saniye (15 dakika)"
else
    log_error "Yapılandırma doğrulanamadı!"
    return 1
fi

echo ""
echo "NOT: Bu ayar pam_faillock modülü etkinleştirildiğinde etkili olacak (5.3.2.2)"
