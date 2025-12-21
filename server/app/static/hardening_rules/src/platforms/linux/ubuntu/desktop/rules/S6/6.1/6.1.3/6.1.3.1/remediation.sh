#!/bin/bash

# 6.1.3.1 Ensure rsyslog is installed (Automated)

echo "Installing rsyslog..."

apt-get update
apt-get install -y rsyslog

echo "rsyslog has been installed"
