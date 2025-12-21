# 5.3.3.1.3 Ensure password failed attempts lockout includes root account (Automated)

**Profile Applicability:**
- **Level 2** - Server
- **Level 2** - Workstation

> 🔴 **KRİTİK UYARI: Bu kural ROOT hesabını kilitleyebilir!**
>
> Bu Level 2 güvenlik kuralıdır. Sadece aşağıdaki durumlarda kullanın:
> - Fiziksel konsol erişiminiz varsa
> - Recovery mode kullanabiliyorsanız
> - Alternatif root erişim yönteminiz varsa (örn: sudo yetkili başka kullanıcı)
>
> `root_unlock_time` ayarlanmazsa ROOT KALICI KİLİTLENEBİLİR!

## Description
Configure faillock to also lock out the root account after failed attempts.

## Rationale
Protecting the root account from brute-force attacks is critical.

## Audit
```bash
grep -Pi -- '^\h*even_deny_root\b' /etc/security/faillock.conf
grep -Pi -- '^\h*root_unlock_time\h*=' /etc/security/faillock.conf
```
Verify `even_deny_root` is set and `root_unlock_time` is 60 or more.

## Remediation
```bash
echo "even_deny_root" >> /etc/security/faillock.conf
echo "root_unlock_time = 60" >> /etc/security/faillock.conf
```

## References
- NIST SP 800-53 Rev. 5: AC-7
