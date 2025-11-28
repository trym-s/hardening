#!/bin/bash
# 3.2.2 Ensure tipc kernel module is not available

module="tipc"

echo "install $module /bin/true" > /etc/modprobe.d/$module.conf
rmmod "$module" 2>/dev/null
