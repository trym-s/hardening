#!/bin/bash

# 6.2.1.1 Ensure auditd packages are installed (Automated)

echo "Installing auditd packages..."

apt-get update
apt-get install -y auditd audispd-plugins

echo "auditd packages have been installed"
