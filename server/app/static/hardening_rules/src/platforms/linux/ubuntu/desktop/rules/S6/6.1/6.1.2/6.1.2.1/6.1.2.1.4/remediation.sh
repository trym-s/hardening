#!/bin/bash

# 6.1.2.1.4 Ensure systemd-journal-remote service is not in use (Automated)

echo "Disabling and stopping systemd-journal-remote service..."

systemctl --now mask systemd-journal-remote.service
systemctl --now mask systemd-journal-remote.socket

echo "systemd-journal-remote service has been masked and stopped"
