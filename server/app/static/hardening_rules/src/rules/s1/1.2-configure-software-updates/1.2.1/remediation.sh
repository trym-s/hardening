#!/bin/bash
if [ -f /usr/sbin/prelink ]; then
    prelink -ua
fi
apt-get remove -y prelink
