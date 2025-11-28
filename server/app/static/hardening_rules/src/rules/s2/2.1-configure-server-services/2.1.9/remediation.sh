#!/bin/bash
systemctl stop nfs-server
systemctl disable nfs-server
apt purge nfs-kernel-server -y
