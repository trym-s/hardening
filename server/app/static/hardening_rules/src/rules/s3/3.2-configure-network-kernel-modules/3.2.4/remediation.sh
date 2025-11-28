#!/bin/bash
# 3.2.4 Ensure sctp kernel module is not available

module="sctp"

echo "install $module /bin/true" > /etc/modprobe.d/$module.conf
rmmod "$module" 2>/dev/null
