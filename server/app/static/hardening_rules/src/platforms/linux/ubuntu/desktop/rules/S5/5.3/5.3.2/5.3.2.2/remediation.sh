#!/bin/bash

# CIS 5.3.2.2 - Ensure pam_faillock module is enabled
#
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  ⚠️  UYARI: Bu kural hesap kilitlemeyi etkinleştirir!                      ║
# ║                                                                            ║
# ║  Bu kuralı uygulamadan ÖNCE şunları yapın:                                 ║
# ║  1. 5.3.3.1.1 - deny parametresini ayarlayın (varsayılan: 3 çok düşük!)  ║
# ║  2. 5.3.3.1.2 - unlock_time parametresini ayarlayın                       ║
# ║  3. Eğer 5.3.3.1.3 uyguladıysanız root kilitlenebilir!                   ║
# ╚════════════════════════════════════════════════════════════════════════════╝

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPERS="${SCRIPT_DIR}/../common/pam_helpers.sh"

# Source helper functions if available
if [ -f "$HELPERS" ]; then
    source "$HELPERS"
else
    log_info() { echo "[INFO] $1"; }
    log_warn() { echo "[WARN] $1"; }
    log_success() { echo "[SUCCESS] $1"; }
    log_error() { echo "[ERROR] $1"; }
    backup_pam_files() { 
        local ts=$(date +%Y%m%d_%H%M%S)
        mkdir -p "/etc/pam.d/.backup_${ts}"
        cp /etc/pam.d/common-{auth,account,password} "/etc/pam.d/.backup_${ts}/" 2>/dev/null
        echo "/etc/pam.d/.backup_${ts}"
    }
fi

FAILLOCK_CONF="/etc/security/faillock.conf"

echo ""
echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║  pam_faillock modülü etkinleştiriliyor                                     ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"

# Önce faillock.conf yapılandırmasını kontrol et
log_info "faillock.conf yapılandırması kontrol ediliyor..."

deny_value=$(grep -Pi '^\s*deny\s*=' "$FAILLOCK_CONF" 2>/dev/null | grep -oP '\d+' | head -1)
unlock_time=$(grep -Pi '^\s*unlock_time\s*=' "$FAILLOCK_CONF" 2>/dev/null | grep -oP '\d+' | head -1)

if [ -z "$deny_value" ]; then
    log_error "deny parametresi ayarlanmamış!"
    log_error "Önce 5.3.3.1.1 kuralını uygulayın!"
    echo ""
    echo "Çözüm: echo 'deny = 5' >> /etc/security/faillock.conf"
    return 1
fi

if [ -z "$unlock_time" ]; then
    log_error "unlock_time parametresi ayarlanmamış!"
    log_error "Önce 5.3.3.1.2 kuralını uygulayın!"
    echo ""
    echo "Çözüm: echo 'unlock_time = 900' >> /etc/security/faillock.conf"
    return 1
fi

log_info "Mevcut yapılandırma: deny=$deny_value, unlock_time=$unlock_time"

if [ "$deny_value" -lt 5 ]; then
    log_warn "deny değeri çok düşük ($deny_value). 5 veya daha yüksek önerilir."
fi

# Zaten etkin mi kontrol et
if grep -q 'pam_faillock\.so' /etc/pam.d/common-auth 2>/dev/null; then
    log_info "pam_faillock zaten etkin"
    grep pam_faillock /etc/pam.d/common-auth
    return 0
fi

# PAM dosyalarını yedekle
log_info "PAM dosyaları yedekleniyor..."
BACKUP_DIR=$(backup_pam_files)
log_info "Yedek dizini: $BACKUP_DIR"

# pam-auth-update'i dene (en güvenli yöntem)
log_info "pam-auth-update ile etkinleştirmeye çalışılıyor..."
if pam-auth-update --enable faillock 2>/dev/null; then
    if grep -q 'pam_faillock\.so' /etc/pam.d/common-auth 2>/dev/null; then
        log_success "pam_faillock modülü pam-auth-update ile etkinleştirildi"
        grep pam_faillock /etc/pam.d/common-auth
        return 0
    fi
fi

# Manuel yapılandırma (pam-auth-update çalışmadıysa)
log_warn "pam-auth-update çalışmadı, manuel yapılandırma yapılıyor..."

# common-auth'a pam_faillock ekle
# Sıra önemli: preauth -> pam_unix -> authfail -> authsucc

# 1. preauth - ilk auth satırından önce
if ! grep -q 'pam_faillock.so preauth' /etc/pam.d/common-auth; then
    sed -i '0,/^auth/{s/^auth/auth    required                        pam_faillock.so preauth\n&/}' /etc/pam.d/common-auth
fi

# 2. authfail - pam_unix.so'dan sonra
if ! grep -q 'pam_faillock.so authfail' /etc/pam.d/common-auth; then
    sed -i '/pam_unix.so/a auth    [default=die]                   pam_faillock.so authfail' /etc/pam.d/common-auth
fi

# 3. authsucc - pam_deny.so'dan önce
if ! grep -q 'pam_faillock.so authsucc' /etc/pam.d/common-auth; then
    sed -i '/pam_deny.so/i auth    sufficient                      pam_faillock.so authsucc' /etc/pam.d/common-auth
fi

# common-account'a ekle
if ! grep -q 'pam_faillock\.so' /etc/pam.d/common-account 2>/dev/null; then
    echo "account required                        pam_faillock.so" >> /etc/pam.d/common-account
fi

# Doğrulama
if grep -q 'pam_faillock\.so' /etc/pam.d/common-auth; then
    log_success "pam_faillock modülü yapılandırıldı"
    echo ""
    echo "common-auth yapılandırması:"
    grep -E '(pam_faillock|pam_unix)' /etc/pam.d/common-auth
    echo ""
    echo "Geri alma gerekirse:"
    echo "  cp $BACKUP_DIR/* /etc/pam.d/"
else
    log_error "Yapılandırma başarısız!"
    log_warn "Yedekler geri yükleniyor..."
    cp "$BACKUP_DIR"/* /etc/pam.d/
    return 1
fi
