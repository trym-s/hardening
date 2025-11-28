#!/bin/bash
# 4.2.4 Ensure ufw loopback traffic is configured

ufw allow in on lo
ufw allow out on lo
ufw deny in from 127.0.0.0/8
ufw deny in from ::1
