# 5.3.2.2 Ensure pam_faillock module is enabled (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

> ⚠️ **UYARI: Bu kural hesap kilitlemeye neden olabilir!**
>
> Bu kuralı uygulamadan ÖNCE şunları yapın:
> 1. **5.3.3.1.1** - `deny` parametresini ayarlayın (varsayılan 3 çok düşük!)
> 2. **5.3.3.1.2** - `unlock_time` parametresini ayarlayın
> 3. **5.3.3.1.3** - Root kilitleme kuralını dikkatli değerlendirin

## Description
The `pam_faillock` module is responsible for locking accounts after a specified number of failed login attempts.

## Rationale
Account lockout helps prevent brute-force password attacks.

## Audit
```bash
grep -P -- '\bpam_faillock\.so\b' /etc/pam.d/common-{auth,account}
```

## Remediation
```bash
pam-auth-update --enable faillock
```

## References
- NIST SP 800-53 Rev. 5: AC-7
