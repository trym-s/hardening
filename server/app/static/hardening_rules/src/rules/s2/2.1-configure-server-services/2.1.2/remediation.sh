#!/bin/bash
systemctl stop avahi-daemon
systemctl disable avahi-daemon
apt purge avahi-daemon -y
