#!/bin/bash
echo "Setting audit config permissions..."
find /etc/audit -type f -exec chmod u-x,g-wx,o-rwx {} \;
echo "Done"
