#!/bin/bash
# 3.2.1 Ensure dccp kernel module is not available

module="dccp"

echo "install $module /bin/true" > /etc/modprobe.d/$module.conf
rmmod "$module" 2>/dev/null
