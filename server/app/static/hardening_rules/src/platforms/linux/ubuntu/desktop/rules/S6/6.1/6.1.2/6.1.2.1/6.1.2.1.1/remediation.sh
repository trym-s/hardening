#!/bin/bash

# 6.1.2.1.1 Ensure systemd-journal-remote is installed (Automated)

echo "Installing systemd-journal-remote..."

apt-get update
apt-get install -y systemd-journal-remote

echo "systemd-journal-remote has been installed"
