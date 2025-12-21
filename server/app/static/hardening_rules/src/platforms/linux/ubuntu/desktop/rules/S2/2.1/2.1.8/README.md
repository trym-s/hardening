# 2.1.8 Ensure message access agent services are not in use (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
A mail server is used to send and receive mail over a network. dovecot-imapd and dovecot-pop3d provide IMAP and POP3 services.

## Rationale
Unless a system is specifically set up to act as a mail server, it is recommended to disable these services.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' dovecot-imapd dovecot-pop3d
systemctl is-enabled dovecot.service 2>/dev/null | grep 'enabled'
```

## Remediation
```bash
systemctl stop dovecot.service
systemctl mask dovecot.service
apt purge dovecot-imapd dovecot-pop3d
```
