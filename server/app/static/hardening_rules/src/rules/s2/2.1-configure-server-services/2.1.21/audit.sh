#!/bin/bash
# 2.1.21 Ensure mail transfer agent is configured for local-only mode

# Check if port 25 is listening on non-loopback interfaces
if ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s'; then
  echo "FAILED: MTA is listening on non-loopback interfaces"
  exit 1
fi

echo "PASSED: MTA is configured for local-only mode"
exit 0
