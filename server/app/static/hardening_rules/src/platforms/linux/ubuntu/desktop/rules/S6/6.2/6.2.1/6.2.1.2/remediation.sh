#!/bin/bash

# 6.2.1.2 Ensure auditd service is enabled and active (Automated)

echo "Enabling and starting auditd service..."

systemctl --now enable auditd

echo "auditd service has been enabled and started"
