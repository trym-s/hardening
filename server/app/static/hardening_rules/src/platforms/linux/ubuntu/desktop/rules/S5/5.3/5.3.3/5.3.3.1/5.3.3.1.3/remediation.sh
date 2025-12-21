#!/bin/bash

# CIS 5.3.3.1.3 - Ensure password failed attempts lockout includes root account
# Configure even_deny_root and root_unlock_time in faillock.conf
#
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  ⚠️  UYARI: Bu kural LEVEL 2'dir!                                          ║
# ║                                                                            ║
# ║  Bu kural ROOT hesabını da kilitler. Dikkatli kullanın!                   ║
# ║  - root_unlock_time ayarlanmazsa ROOT KALICI KİLİTLENEBİLİR              ║
# ║  - Konsol erişiminiz yoksa sisteme erişiminizi kaybedebilirsiniz         ║
# ║  - Recovery mode veya live USB gerekebilir                                ║
# ╚════════════════════════════════════════════════════════════════════════════╝

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPERS="${SCRIPT_DIR}/../../common/pam_helpers.sh"

# Source helper functions if available
if [ -f "$HELPERS" ]; then
    source "$HELPERS"
else
    log_info() { echo "[INFO] $1"; }
    log_warn() { echo "[WARN] $1"; }
    log_success() { echo "[SUCCESS] $1"; }
    log_error() { echo "[ERROR] $1"; }
fi

FAILLOCK_CONF="/etc/security/faillock.conf"
ROOT_UNLOCK_TIME=60  # 60 saniye - root için daha kısa süre

echo ""
echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║  ⚠️  UYARI: Bu kural ROOT hesabını kilitleyebilir!                         ║"
echo "║                                                                            ║"
echo "║  Bu Level 2 güvenlik kuralıdır. Sadece aşağıdaki durumlarda kullanın:     ║"
echo "║  - Fiziksel konsol erişiminiz varsa                                       ║"
echo "║  - Recovery mode kullanabiliyorsanız                                      ║"
echo "║  - Alternatif root erişim yönteminiz varsa                                ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Kullanıcı onayı iste (interaktif modda)
if [ -t 0 ]; then
    read -p "Devam etmek istiyor musunuz? (evet/hayır): " confirm
    if [[ "$confirm" != "evet" && "$confirm" != "EVET" && "$confirm" != "e" && "$confirm" != "E" ]]; then
        log_warn "İptal edildi."
        return 0
    fi
fi

log_info "Root hesabı kilitleme yapılandırılıyor..."

# Dosya yoksa oluştur
if [ ! -f "$FAILLOCK_CONF" ]; then
    touch "$FAILLOCK_CONF"
fi

# even_deny_root ekle (duplicate önleme)
if ! grep -qi '^\s*even_deny_root\s*$' "$FAILLOCK_CONF" 2>/dev/null; then
    if grep -qi '^#\s*even_deny_root' "$FAILLOCK_CONF" 2>/dev/null; then
        sed -i 's/^#\s*even_deny_root.*/even_deny_root/' "$FAILLOCK_CONF"
        log_info "Aktifleştirildi: even_deny_root"
    else
        echo "even_deny_root" >> "$FAILLOCK_CONF"
        log_info "Eklendi: even_deny_root"
    fi
else
    log_info "Zaten mevcut: even_deny_root"
fi

# root_unlock_time ekle/güncelle - BU ÇOK ÖNEMLİ!
if grep -qi '^\s*root_unlock_time\s*=' "$FAILLOCK_CONF" 2>/dev/null; then
    sed -i 's/^\s*root_unlock_time\s*=.*/root_unlock_time = '"$ROOT_UNLOCK_TIME"'/' "$FAILLOCK_CONF"
    log_info "Güncellendi: root_unlock_time = $ROOT_UNLOCK_TIME"
elif grep -qi '^#\s*root_unlock_time\s*=' "$FAILLOCK_CONF" 2>/dev/null; then
    sed -i 's/^#\s*root_unlock_time\s*=.*/root_unlock_time = '"$ROOT_UNLOCK_TIME"'/' "$FAILLOCK_CONF"
    log_info "Aktifleştirildi: root_unlock_time = $ROOT_UNLOCK_TIME"
else
    echo "root_unlock_time = $ROOT_UNLOCK_TIME" >> "$FAILLOCK_CONF"
    log_info "Eklendi: root_unlock_time = $ROOT_UNLOCK_TIME"
fi

# Doğrulama
if grep -qi '^\s*even_deny_root' "$FAILLOCK_CONF" && grep -qi "^\s*root_unlock_time\s*=\s*$ROOT_UNLOCK_TIME" "$FAILLOCK_CONF"; then
    log_success "Root hesabı kilitleme yapılandırıldı"
    echo ""
    echo "Yapılandırma:"
    echo "  - even_deny_root: Root hesabı da kilitlenecek"
    echo "  - root_unlock_time: $ROOT_UNLOCK_TIME saniye sonra otomatik açılacak"
else
    log_error "Yapılandırma doğrulanamadı!"
    return 1
fi

echo ""
echo "ÖNEMLİ: Root hesabını açmak için:"
echo "  faillock --user root --reset"
