#!/bin/bash

# 6.1.1.1 Ensure journald service is enabled and active (Automated)

echo "Enabling and starting systemd-journald service..."

systemctl unmask systemd-journald.service
systemctl --now enable systemd-journald.service

echo "systemd-journald service has been enabled and started"
