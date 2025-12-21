# 5.1.21 Ensure sshd PermitUserEnvironment is disabled (Automated)

## Description
The `PermitUserEnvironment` option allows users to present environment options to the SSH daemon.

## Rationale
Permitting users to set environment variables through the SSH daemon could potentially allow users to bypass security controls.

## Audit
```bash
sshd -T | grep permituserenvironment
```
Should return `permituserenvironment no`.

## Remediation
```bash
echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config
systemctl reload sshd
```
