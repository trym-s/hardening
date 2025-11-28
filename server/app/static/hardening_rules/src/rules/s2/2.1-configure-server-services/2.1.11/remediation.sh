#!/bin/bash
systemctl stop cups
systemctl disable cups
apt purge cups -y
