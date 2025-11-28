#!/bin/bash
systemctl stop dnsmasq
systemctl disable dnsmasq
apt purge dnsmasq -y
