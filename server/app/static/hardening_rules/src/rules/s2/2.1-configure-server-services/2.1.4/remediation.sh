#!/bin/bash
systemctl stop bind9
systemctl disable bind9
apt purge bind9 -y
