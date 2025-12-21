#!/bin/bash

# 6.1.3.2 Ensure rsyslog service is enabled and active (Automated)

echo "Enabling and starting rsyslog service..."

systemctl --now enable rsyslog

echo "rsyslog service has been enabled and started"
