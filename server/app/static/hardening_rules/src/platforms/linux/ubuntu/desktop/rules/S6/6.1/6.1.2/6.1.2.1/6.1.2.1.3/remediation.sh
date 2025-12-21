#!/bin/bash

# 6.1.2.1.3 Ensure systemd-journal-upload is enabled and active (Automated)

echo "Enabling and starting systemd-journal-upload service..."

systemctl --now enable systemd-journal-upload.service

echo "systemd-journal-upload service has been enabled and started"
