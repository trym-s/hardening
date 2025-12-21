# 5.1.12 Ensure sshd KexAlgorithms are configured (Automated)

## Description
Key exchange algorithms are used to establish a secure connection between the SSH client and server.

## Rationale
Weak key exchange algorithms should not be used. Only strong algorithms should be allowed.

## Audit
```bash
sshd -T | grep -i kexalgorithms
```
Verify only approved strong key exchange algorithms are listed.

## Remediation
```bash
echo "KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256" >> /etc/ssh/sshd_config
systemctl reload sshd
```
