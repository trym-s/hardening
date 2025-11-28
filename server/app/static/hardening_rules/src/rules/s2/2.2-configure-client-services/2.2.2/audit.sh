#!/bin/bash
# 2.2.2 Ensure ldap client is not installed

if dpkg -l | grep -q ldap-utils; then
  echo "FAILED: ldap-utils is installed"
  exit 1
fi

echo "PASSED: ldap client is not installed"
exit 0
