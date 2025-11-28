#!/bin/bash
systemctl stop slapd
systemctl disable slapd
apt purge slapd -y
