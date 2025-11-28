#!/bin/bash
# 4.2.3 Ensure ufw service is enabled

ufw --force enable
systemctl enable ufw
