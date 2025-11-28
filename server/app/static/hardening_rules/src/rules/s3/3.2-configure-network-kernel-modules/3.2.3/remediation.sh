#!/bin/bash
# 3.2.3 Ensure rds kernel module is not available

module="rds"

echo "install $module /bin/true" > /etc/modprobe.d/$module.conf
rmmod "$module" 2>/dev/null
