#!/bin/bash
systemctl stop dovecot
systemctl disable dovecot
apt purge dovecot-core dovecot-imapd dovecot-pop3d -y
