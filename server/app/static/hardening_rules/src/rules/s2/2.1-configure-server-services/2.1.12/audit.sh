#!/bin/bash
# 2.1.12 Ensure rpcbind services are not in use

# Check if rpcbind is enabled
if systemctl is-enabled rpcbind | grep -q 'enabled'; then
  echo "FAILED: rpcbind is enabled"
  exit 1
fi

# Check if rpcbind is active
if systemctl is-active rpcbind | grep -q 'active'; then
  echo "FAILED: rpcbind is active"
  exit 1
fi

echo "PASSED: rpcbind services are not in use"
exit 0
