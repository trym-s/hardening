# 5.1.14 Ensure sshd LogLevel is configured (Automated)

## Description
`INFO` level logging is the basic level that only records login activity.

## Rationale
SSH provides several logging levels. `VERBOSE` or `INFO` level is recommended for logging.

## Audit
```bash
sshd -T | grep loglevel
```
Should return `loglevel VERBOSE` or `loglevel INFO`.

## Remediation
```bash
echo "LogLevel VERBOSE" >> /etc/ssh/sshd_config
systemctl reload sshd
```
