#!/bin/bash
systemctl stop isc-dhcp-server
systemctl disable isc-dhcp-server
apt purge isc-dhcp-server -y
