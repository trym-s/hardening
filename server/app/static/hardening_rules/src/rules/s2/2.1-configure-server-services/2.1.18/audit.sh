#!/bin/bash
# 2.1.18 Ensure web server services are not in use

# Check apache2
if systemctl is-enabled apache2 2>/dev/null | grep -q 'enabled'; then
  echo "FAILED: apache2 is enabled"
  exit 1
fi
if systemctl is-active apache2 2>/dev/null | grep -q 'active'; then
  echo "FAILED: apache2 is active"
  exit 1
fi

# Check nginx
if systemctl is-enabled nginx 2>/dev/null | grep -q 'enabled'; then
  echo "FAILED: nginx is enabled"
  exit 1
fi
if systemctl is-active nginx 2>/dev/null | grep -q 'active'; then
  echo "FAILED: nginx is active"
  exit 1
fi

echo "PASSED: web server services are not in use"
exit 0
