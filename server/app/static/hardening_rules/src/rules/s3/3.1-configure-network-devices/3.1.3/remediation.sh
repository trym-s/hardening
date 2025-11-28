#!/bin/bash
# 3.1.3 Ensure bluetooth services are not in use

systemctl stop bluetooth
systemctl mask bluetooth
