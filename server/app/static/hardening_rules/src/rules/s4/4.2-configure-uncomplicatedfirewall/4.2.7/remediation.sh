#!/bin/bash
# 4.2.7 Ensure ufw default deny firewall policy

ufw default deny incoming
ufw default allow outgoing
ufw default deny routed
