#!/bin/bash
systemctl stop autofs
systemctl disable autofs
apt purge autofs -y
